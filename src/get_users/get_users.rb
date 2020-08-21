require 'aws-sdk'
require 'json'
require 'open-uri'
require 'constants'
require 'private_methods'

def handler(event:, context:)

  url = SLACK_API_URL + "/users.list?token=#{slack_token}"
  members_info = JSON.load(open(url).read)['members']

  ddb = Aws::DynamoDB::Client.new(region: 'ap-northeast-1')
  table_name = ENV['DDB_TABLE']
  
  items = ddb.scan({table_name: table_name})
  
  p items

  p members_info[0]['id']
  p members_info[0]['name']
  p members_info[0]['team_id']
  
  # 200ステータスを返す
  ACK
end
