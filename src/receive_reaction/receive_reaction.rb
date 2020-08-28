# frozen_string_literal: true

require 'layer_constants'
require 'layer_methods'

FOUND_CANDIDATE_MESSAGE = '相談相手が見つかりました！'

def handler(event:, context:)
  puts '## リアクション受信・通知転送処理'

  candidate_id = event['candidate_id']
  question_user_id, question_body = find_question(event)

  slack_api_method = SLACK_API_METHODS[:post_message]
  params = {
    channel: "@#{question_user_id}",
    blocks: create_blocks(candidate_id),
    text: FOUND_CANDIDATE_MESSAGE
  }
  response = call_post_to_slack(slack_api_method, params)
  put_log(question_user_id, question_body, candidate_id, response)
end

private

def put_log(question_user_id, question_body, candidate_id, response)
  # 実行結果ログ
  puts '## 相談者ID'
  puts question_user_id
  puts '## 相談概要'
  puts question_body
  puts '## 相談相手候補者ID'
  puts candidate_id
  puts '## レスポンス：ステータスコード'
  puts response.code
  puts '## レスポンス：本文'
  puts response.body
end

def find_question(event)
  question_id = event['question_id']
  question_user_id = find_by(question_id, 'UserId')
  question_body = find_by(question_id, 'Body')

  [question_user_id, question_body]
end

def create_blocks(candidate_id) # rubocop:disable Metrics/MethodLength
  message =
    "*#{FOUND_CANDIDATE_MESSAGE}*\n<@#{candidate_id}> さんが相談相手になってくれるようです！連絡を取ってみましょう。"
  [
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: message
      }
    },
    {
      type: 'actions',
      elements: [
        {
          type: 'button',
          text: {
            type: 'plain_text',
            emoji: true,
            text: '解決 :grin:'
          },
          style: 'primary'
        }
      ]
    }
  ]
end
