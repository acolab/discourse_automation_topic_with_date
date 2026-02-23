# discourse-automation-topic-with-date

A [discourse-automation](https://github.com/discourse/discourse/tree/main/plugins/automation) addon that adds a "Topic with Date" scriptable.

It creates a topic with a computed `{{date}}` placeholder and optional wiki support on the first post.

## Fields

| Field         | Type     | Description                                        |
|---------------|----------|----------------------------------------------------|
| `title`       | text     | Topic title (supports `{{date}}` placeholder)      |
| `body`        | post     | Topic body (supports `{{date}}` placeholder)       |
| `category`    | category | Target category                                    |
| `tags`        | tags     | Optional tags                                      |
| `wiki`        | boolean  | Make the first post a wiki                         |
| `date_offset` | text     | Days to add to today for `{{date}}` (default: `0`) |
| `date_format` | text     | strftime format (default: `%d/%m/%Y`)              |

## Triggers

- `recurring` -- for periodic topic creation
- `point_in_time` -- for one-off scheduled creation

## Installation

Add to your `app.yml` under the plugin clone commands:

```yaml
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/acolab/discourse_automation_topic_with_date.git discourse_automation_topic_with_date
```

Then rebuild: `./launcher rebuild app`

For development, symlink into `plugins/`:

```
ln -s /path/to/discourse_automation_topic_with_date /path/to/discourse/plugins/
```

## License

GPL-2.0 -- see [LICENSE](LICENSE).
