require 'json'

private

# 相談解決処理を行う
def solve_question(body)
  return unless body
  return unless body['actions']
  return unless body['actions'][0]['action_id'] == 'solve_question'

  value = JSON.parse(body['actions'][0]['value'])
  payload = {
    question_id: value['question_id'],
    solver_id: value['solver_id']
  }.to_json

  execute_lambda(function_name: ENV['SOLVE_QUESTION_FUNCTION_NAME'], payload: payload)
end
