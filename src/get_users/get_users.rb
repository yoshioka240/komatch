require 'json'
require 'uri'
require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  url = SLACK_API_URL + "/users.list?token=#{slack_token}"
  users_info = JSON.parse(URI.open(url).read)['members']

  attrs = %w[name team_id]

  users_info.each do |user_info|
    attrs.each do |attr|
      put_item(user_info['id'], attr, user_info[attr])
    end
  end

  # 200ステータスを返す
  ACK
end
