require 'layer_constants'
require 'layer_methods'

require_relative 'private_methods'

def handler(event:, context:)
  p '## 質問の完了'
  question_id = event['question_id']
  question_body = find_by(question_id, 'body')

  user_id = find_by(question_id, 'UserId')
  solver_id = event['solver_id']

  put_item(question_id, 'SolverId', solver_id)
  p '## 質問ID'
  p question_id
  p '## 解決者ID'
  p solver_id

  notify_solve_complete(user_id, question_body)

  ACK
end
