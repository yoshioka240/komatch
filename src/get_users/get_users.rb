require 'json'
require 'uri'
require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  table_name = ENV['DDB_TABLE']
  url = SLACK_API_URL + "/users.list?token=#{slack_token}"
  users_info = JSON.parse(URI.open(url).read)['members']

  attrs = { Name: 'name', WorkspaceId: 'team_id' }
  users_info.each do |user_info|
    attrs.each do |k, v|
      item = { id: user_info['id'], data_type: k, data_value: user_info[v] }
      dynamodb.put_item({ table_name: table_name, item: item })
    end
  end

  # 200ステータスを返す
  ACK
end
