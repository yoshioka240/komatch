# frozen_string_literal: true

require 'layer_constants'
require 'layer_methods'

RECEIVED_QUESTION_MESSAGE = '相談が届きました。'

def handler(event:, context:)
  puts '## 質問の通知'

  slack_api_method = SLACK_API_METHODS[:post_message]
  question_id, question_body = find_question(event)
  # TODO: OutputPathの見直し
  event['user_ids']['user_ids'].each do |user_id|
    params = {
      channel: "@#{user_id}",
      blocks: create_blocks(question_id, question_body),
      text: RECEIVED_QUESTION_MESSAGE
    }
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

def find_question(event)
  question_id = event['question_id']['question_id']
  question_body = find_by(question_id, 'Body')

  [question_id, question_body]
end

def create_blocks(question_id, question_body)
  [
    create_text(question_body),
    {
      'type': 'actions',
      'elements': [
        create_ok_button(question_id),
        create_ng_button(question_id)
      ]
    }
  ]
end

def create_text(question_body)
  {
    'type': 'section',
    'text': {
      'type': 'mrkdwn',
      'text': "#{RECEIVED_QUESTION_MESSAGE}\n\n```#{question_body}```\n\nこちらの相談に乗ってみませんか？"
    }
  }
end

def create_ok_button(question_id)
  {
    'type': 'button',
    'text': {
      'type': 'plain_text',
      'text': 'OK'
    },
    'action_id': 'react_ok_response',
    'value': question_id,
    'style': 'primary'
  }
end

def create_ng_button(question_id)
  {
    'type': 'button',
    'text': {
      'type': 'plain_text',
      'text': 'NG'
    },
    'action_id': 'react_ng_response',
    'value': question_id,
    'style': 'danger'
  }
end
