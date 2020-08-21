require 'aws-sdk'
require 'layer_constants'
require 'layer_methods'

require_relative 'constants'
require_relative 'private_methods'

def handler(event:, context:)
  puts '## ユーザの選定'

  question_id = event['question_id']
  return 'error' unless question_id

  puts '## 質問ID'
  puts question_id

  user_ids = check_not_sent_user_ids(question_id)
  puts '## 通知を送ったユーザ'
  puts user_ids

  # 質問したユーザの情報を取得
  { user_ids: user_ids }.to_json
end
