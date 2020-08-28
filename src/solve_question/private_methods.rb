private

def notify_solve_complete(user_id, question_body)
  p '## 相談解決処理完了通知'
  slack_api_method = SLACK_API_METHODS[:post_message]
  params = {
    channel: "@#{user_id}",
    blocks: notify_solve_completion_blocks(question_body)
  }
  response = call_post_to_slack(slack_api_method, params)

  # 実行結果ログ
  p '## 相談者ID'
  p user_id
  p '## レスポンス：ステータスコード'
  p response.code
  p '## レスポンス：本文'
  p response.body
end

def notify_solve_completion_blocks(question_body) # rubocop:disable Metrics/MethodLength
  [
    {
      type: 'section',
      text: {
        type: 'plain_text',
        text: '相談が解決しました。おめでとうございます！',
        emoji: true
      }
    },
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: ">#{question_body}"
      }
    }
  ]
end
