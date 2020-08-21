# frozen_string_literal: true

### -------- ###
### 定数管理 ###
### -------- ###

# 200レスポンス
ACK = {
  statusCode: 200,
  body: JSON.generate('OK')
}.freeze

# Slack API URL
SLACK_API_URL = 'https://slack.com/api'

# Slack API Methods
SLACK_API_METHODS = {
  views_publish: 'views.publish'
}.freeze

# Homeタブ初期表示内容
INITIAL_HOME_VIEW = {
  type: 'home',
  blocks: [
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: "Welcome to Komatch! (#{Time.now})"
      }
    }
  ]
}.to_json
