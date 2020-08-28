require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  puts '## 質問の通知'

  slack_api_method = SLACK_API_METHODS[:post_message]
  event['user_ids'].each do |user_id|
    params = { channel: "@#{user_id}", blocks: create_blocks }
    response = call_post_to_slack(slack_api_method, params)
    put_log(user_id, response)
  end
end

private

def put_log(user_id, response)
  # 実行結果ログ
  puts '## user_id'
  puts user_id
  puts '## レスポンス：ステータスコード'
  puts response.code
  puts '## レスポンス：本文'
  puts response.body
end

def create_blocks
  [
    create_text('相談が届きました。'),
    {
      'type': 'actions',
      'elements': [
        create_button('OK'),
        create_button('NG')
      ]
    }
  ]
end

def create_text(text)
  {
    'type': 'section',
    'text': {
      'type': 'plain_text',
      'text': text,
      'emoji': true
    }
  }
end

def create_button(text)
  {
    'type': 'button',
    'text': {
      'type': 'plain_text',
      'text': text,
      'emoji': true
    },
    'value': 'click_me_123'
  }
end
