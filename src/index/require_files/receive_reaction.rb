require 'json'

private

# 相談概要を受け取る
def receive_reaction(body)
  return unless body
  return unless body['actions']
  return unless body['actions'][0]['action_id'] == 'react_ok_response'

  payload = {
    question_id: body['actions'][0]['value'],
    candidate_id: body['user']['id']
  }.to_json

  execute_lambda(function_name: ENV['RECEIVE_REACTION_FUNCTION_NAME'], payload: payload)
end
