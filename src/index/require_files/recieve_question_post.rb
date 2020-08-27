require 'json'

private

# 相談概要を受け取る
def recieve_question_post(body)
  return unless body
  return unless body['type'] == 'view_submission'

  step_functions.start_execution(
    {
      state_machine_arn: 'arn:aws:states:ap-northeast-1:071996776131:stateMachine:dev2-StateMachine',
      input: { text: extract_question(body), body: body }.to_json
    }
  )

  # ログ
  p '## user_id'
  p body['user']['id']
  p '## 相談概要'
  p question

  # TODO: 相談概要投稿完了モーダルを表示
  RECEIVED_QUESTION_MODAL
end

def step_functions
  Aws::States::Client.new
end

def extract_question(body)
  block = body['view']['blocks'][0]
  block_id = block['block_id']
  action_id = block['element']['action_id']
  body['view']['state']['values'][block_id][action_id]['value']
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
            text: '相談概要を投稿しました！'
          }
        }
      ]
    }
  }.to_json
