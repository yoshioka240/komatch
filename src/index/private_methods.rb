private

# Slack AppのHomeタブの初期表示処理
def display_home(user_id)
  # Slack API メソッド
  slack_api_method = SLACK_API_METHODS[:views_publish]

  # APIに渡すパラメータ
  params = {
    user_id: user_id,
    view: INITIAL_HOME_VIEW
  }

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

# Slack Token
def slack_token
  # SSMパラメータストアから Slack Token を取得
  ssm_client = Aws::SSM::Client.new
  ssm_param = { name: "#{ENV['env']}_komatch_slack_token", with_decryption: true }
  ssm_client.get_parameter(ssm_param).parameter.value
end

# Slack API に対し POST リクエストを実行
def call_post_to_slack(slack_api_method = nil, params = {})
  # POST 実行 準備
  uri = URI.parse(File.join(SLACK_API_URL, slack_api_method))
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'

  # APIに渡すヘッダー
  header = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer #{slack_token}"
  }

  # POST 実行
  http.post(uri.path, params.to_json, header)
end
