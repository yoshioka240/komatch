require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  puts '## 質問の完了'
  question_id = event['question_id']
  user_id = event['user_id']

  put_item(question_id, 'SolverId', user_id)
  puts '## 質問ID'
  puts question_id
  puts '## 解決者ID'
  puts user_id

  ACK
end
