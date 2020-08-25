require 'json'

private

# 相談概要を受け取る
def recieve_question_post(body)
  return unless body
  return unless body['type'] == 'view_submission'

  block = body['view']['blocks'][0]
  block_id = block['block_id']
  action_id = block['element']['action_id']
  question = body['view']['state']['values'][block_id][action_id]['value']

  # TODO: DynamoDBへの登録

  # ログ
  p '## user_id'
  p body['user']['id']
  p '## 相談概要'
  p question

  # TODO: 相談概要投稿完了モーダルを表示
  RECEIVED_QUESTION_MODAL
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
