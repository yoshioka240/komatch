private

# Slack AppのHomeタブの初期表示処理
def display_home(user_id)
  # Slack API メソッド
  slack_api_method = SLACK_API_METHODS[:views_publish]

  # APIに渡すパラメータ
  params = { user_id: user_id, view: INITIAL_HOME_VIEW }

  # Homeタブ表示のAPI実行
  response = call_post_to_slack(slack_api_method, params)

  # 実行結果ログ
  puts '## user_id'
  puts user_id
  puts '## レスポンス：ステータスコード'
  puts response.code
  puts '## レスポンス：本文'
  puts response.body
end
