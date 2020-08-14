require 'aws-sdk'
require 'json'
require 'net/http'
require 'uri'
require_relative 'constants'

def handler(event:, context:)
  puts '## Slackの情報'
  puts event.to_a

  # チャレンジ認証
  return { challenge: event['challenge'] } if event['challenge']

  # Slack AppのHomeタブの初期表示処理
  display_home(event['event']['user']) if event['event']['type'].to_s == 'app_home_opened'

  # 200ステータスを返す
  ACK
end

private

# Slack AppのHomeタブの初期表示処理
def display_home(user_id)
  # POST実行準備
  uri = URI.parse(File.join(SLACK_API_URL, 'views.publish'))
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === 'https'

  # SSMパラメータストアから Slack Token を取得
  ssm_client = Aws::SSM::Client.new
  ssm_param = { name: "#{ENV['env']}_komatch_slack_token", with_decryption: true }
  slack_token = ssm_client.get_parameter(ssm_param).parameter.value
  # APIに渡すヘッダー
  header = {
    'Content-Type': 'application/json',
    'Authorization': "Bearer #{slack_token}"
  }
  # APIに渡すパラメータ
  params = {
    user_id: user_id,
    view: INITIAL_HOME_VIEW
  }

  # Homeタブ表示のAPI実行
  response = http.post(uri.path, params.to_json, header)

  # 実行結果ログ
  puts '## user_id'
  puts user_id
  puts '## レスポンス：ステータスコード'
  puts response.code
  puts '## レスポンス：本文'
  puts response.body
end
