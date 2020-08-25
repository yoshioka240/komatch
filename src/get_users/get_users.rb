require 'json'
require 'uri'
require 'layer_constants'
require 'layer_methods'

ATTRS = { Name: 'name', WorkspaceId: 'team_id' }.freeze

def handler(event:, context:)
  url = SLACK_API_URL + "/users.list?token=#{slack_token}"
  users_info = JSON.parse(URI.open(url).read)['members']

  # 1度にPUTできる数は25とのことなので、ユーザー毎に必要なアイテムをPUTする
  users_info.each do |user_info|
    items = ATTRS.map { |k, v| generate_item_for_batch_write(user_info['id'], k, user_info[v]) }
    batch_write_item(items)
  end

  # 200ステータスを返す
  ACK
end
