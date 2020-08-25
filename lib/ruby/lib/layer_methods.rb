require 'aws-sdk'
require 'open-uri'
require 'net/http'

private

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

# DynamoDB関連

def dynamodb
  Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
end

# テーブル指定
def table_name
  @table_name ||= ENV['DDB_TABLE']
end

# item取得まで
def get_item(key, data_type)
  dynamodb.get_item(table_name: table_name, key: { id: key, data_type: data_type }).item
end

# 要素まで取得する
def find_by(key, data_type)
  get_item(key, data_type)&.dig('data_value')
end

# 要素を1件作成/更新
def put_item(id, data_type, data_value)
  dynamodb.put_item(
    table_name: table_name,
    item: {
      id: id,
      data_type: data_type,
      data_value: data_value
    }
  )
end

# 一度に複数アイテム作成
def batch_write_item(items)
  dynamodb.batch_write_item({ request_items: { table_name => items } })
end

def generate_item_for_batch_write(id, key, value)
  {
    put_request: {
      item: {
        id: id,
        data_type: key,
        data_value: value
      }
    }
  }
end
