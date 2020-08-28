# frozen_string_literal: true

require 'json'

private

POST_COMPLETION_MESSAGE = '相談概要の投稿が完了しました！'

# 相談概要を受け取る
def receive_question_post(body)
  return unless body
  return unless body['type'] == 'view_submission'

  user_id, question = parse_body(body)

  call_step_functions(body, question)

  p '## 相談概要ログ'
  p '## user_id'
  p user_id
  p '## 相談概要'
  p question

  # 相談概要投稿完了通知
  notify_post_completion(user_id, question)

  # モーダル削除リクエストをレスポンスとして返却
  RECEIVED_QUESTION_MODAL
end

def parse_body(body)
  # user_id
  user_id = body['user']['id']

  # question
  block = body['view']['blocks'][0]
  block_id = block['block_id']
  action_id = block['element']['action_id']
  question = body['view']['state']['values'][block_id][action_id]['value']

  [user_id, question]
end

def call_step_functions(body, question)
  step_functions.start_execution(
    {
      state_machine_arn: ENV['STEP_FUNCTIONS_ARN'],
      input: { text: question, body: body }.to_json
    }
  )
end

def step_functions
  Aws::States::Client.new
end

def notify_post_completion(user_id, question)
  p '## 相談概要投稿完了通知'
  slack_api_method = SLACK_API_METHODS[:post_message]
  params = {
    channel: "@#{user_id}",
    blocks: notify_post_completion_blocks(question),
    text: POST_COMPLETION_MESSAGE
  }
  response = call_post_to_slack(slack_api_method, params)

  # 実行結果ログ
  p '## user_id'
  p user_id
  p '## レスポンス：ステータスコード'
  p response.code
  p '## レスポンス：本文'
  p response.body
end

def notify_post_completion_blocks(question) # rubocop:disable Metrics/MethodLength
  [
    {
      type: 'section',
      text: {
        type: 'plain_text',
        text: POST_COMPLETION_MESSAGE,
        emoji: true
      }
    },
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: ">#{question}"
      }
    }
  ]
end

# 相談概要投稿完了モーダル表示内容
RECEIVED_QUESTION_MODAL =
  {
    response_action: 'update',
    view: {
      type: 'modal',
      title: {
        type: 'plain_text',
        text: 'こまっち',
        emoji: true
      },
      close: {
        type: 'plain_text',
        text: 'Close',
        emoji: true
      },
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: '相談概要の投稿が完了しました！'
          }
        }
      ]
    }
  }.freeze
