# frozen_string_literal: true

# name: discourse-automation-topic-with-date
# about: Adds a "Topic with Date" scriptable to discourse-automation. Creates a topic with a computed {{date}} placeholder and optional wiki support.
# version: 0.1
# authors: ACoLab
# url: https://music.music/acolabot
# required_version: 2.7.0

after_initialize do
  DiscourseAutomation::Scriptable.add("topic_with_date") do
    version 1

    field :title, component: :text, required: true, accepts_placeholders: true
    field :body, component: :post, required: true, accepts_placeholders: true
    field :category, component: :category, required: true
    field :tags, component: :tags
    field :wiki, component: :boolean
    field :date_offset, component: :text
    field :date_format, component: :text

    placeholder :date

    triggerables %i[recurring point_in_time]

    script do |context, fields, automation|
      date_offset = fields.dig("date_offset", "value") || "0"
      date_format = fields.dig("date_format", "value").presence || "%d/%m/%Y"
      computed_date = (Date.today + date_offset.to_i).strftime(date_format)

      placeholders = (context["placeholders"] || {}).merge({ date: computed_date })

      topic_raw = utils.apply_placeholders(fields.dig("body", "value"), placeholders)
      title = utils.apply_placeholders(fields.dig("title", "value"), placeholders)

      category_id = fields.dig("category", "value")
      category = Category.find_by(id: category_id)
      if !category
        DiscourseAutomation::Logger.warn("category of id: `#{category_id}` was not found")
        next
      end

      tags = fields.dig("tags", "value") || []

      post_creator = PostCreator.new(
        Discourse.system_user,
        raw: topic_raw,
        title: title,
        category: category.id,
        tags: tags,
      )
      new_post = post_creator.create

      if new_post.blank? || post_creator.errors.present?
        DiscourseAutomation::Logger.error(
          "Failed to create topic '#{title}': #{post_creator.errors.full_messages.join(", ")}",
        )
        next
      end

      if fields.dig("wiki", "value")
        new_post.revise(Discourse.system_user, wiki: true)
      end
    end
  end
end
