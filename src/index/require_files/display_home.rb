require 'json'

private

# Slack AppのHomeタブの初期表示処理
def display_home(event)
  return unless event
  return unless event['type'].to_s == 'app_home_opened'

  # APIリクエストから user_id を取得
  user_id = event['user_id']

  # Slack API メソッド
  slack_api_method = SLACK_API_METHODS[:views_publish]

  # APIに渡すパラメータ
  params = { user_id: user_id, view: INITIAL_HOME_VIEW }

  # Homeタブ表示のAPI実行
  response = call_post_to_slack(slack_api_method, params)

  # 実行結果ログ
  p '## user_id'
  p user_id
  p '## レスポンス：ステータスコード'
  p response.code
  p '## レスポンス：本文'
  p response.body
end

# Homeタブ初期表示内容
INITIAL_HOME_VIEW =
  {
    type: 'home',
    blocks: [
      {
        type: 'header',
        text: {
          type: 'plain_text',
          text: 'こまっちへようこそ！'
        }
      },
      {
        type: 'actions',
        elements: [
          {
            type: 'button',
            action_id: 'open_modal_clicked',
            text: {
              type: 'plain_text',
              text: '相談相手を探す',
              emoji: true
            }
          }
        ]
      }
    ]
  }.to_json
