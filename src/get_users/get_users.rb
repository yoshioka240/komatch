require 'json'
require 'uri'
require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  table_name = ENV['DDB_TABLE']

  url = SLACK_API_URL + "/users.list?token=#{slack_token}"
  members_info = JSON.parse(URI.open(url).read)['members']

  table_name = ENV['DDB_TABLE']
  items = dynamodb.scan({ table_name: table_name })

  # 200ステータスを返す
  ACK
end
