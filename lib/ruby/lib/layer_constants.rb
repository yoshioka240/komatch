# frozen_string_literal: true

require 'json'

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
  views_publish: 'views.publish',
  views_open: 'views.open',
  post_message: 'chat.postMessage'
}.freeze
