require 'json'

private

# 相談概要入力フォームモーダルを出す
def render_question_post_modal(body)
  return unless body
  return unless body['actions']
  return unless body['actions'][0]['action_id'] == 'open_modal_clicked'

  # Slack API メソッド
  slack_api_method = SLACK_API_METHODS[:views_open]

  # APIに渡すパラメータ
  params = { trigger_id: body['trigger_id'], view: QUESTION_POST_MODAL_VIEW }

  # Homeタブ表示のAPI実行
  response = call_post_to_slack(slack_api_method, params)

  # 実行結果ログ
  p '## レスポンス：ステータスコード'
  p response.code
  p '## レスポンス：本文'
  p response.body
end

# 相談概要投稿フォームモーダル表示内容
QUESTION_POST_MODAL_VIEW =
  {
    type: 'modal',
    title: {
      type: 'plain_text',
      text: 'こまっち',
      emoji: true
    },
    submit: {
      type: 'plain_text',
      text: 'Submit',
      emoji: true
    },
    close: {
      type: 'plain_text',
      text: 'Cancel',
      emoji: true
    },
    blocks: [
      {
        type: 'input',
        element: {
          type: 'plain_text_input',
          multiline: true
        },
        label: {
          type: 'plain_text',
          text: '相談概要を書きましょう',
          emoji: true
        }
      }
    ]
  }.freeze
