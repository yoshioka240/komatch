require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  puts '## 質問の通知'

  slack_api_method = SLACK_API_METHODS[:post_message]
  target_users(event).items.each do |user|
    params = { channel: "@#{user['id']}", text: '相談が届きました。' }
    response = call_post_to_slack(slack_api_method, params)
    put_log(user, response)
  end
end

private

# TODO: キーワードから抽出したユーザーを取得できるようにする
def target_users(_event)
  dynamodb.query(
    table_name: ENV['DDB_TABLE'],
    index_name: 'GSI1',
    projection_expression: 'id',
    key_condition_expression: 'data_value = :data_value',
    expression_attribute_values: {
      ':data_value' => 'T017X0LTP42'
    }
  )
end

def put_log(user, response)
  # 実行結果ログ
  puts '## user'
  puts user
  puts '## レスポンス：ステータスコード'
  puts response.code
  puts '## レスポンス：本文'
  puts response.body
end
