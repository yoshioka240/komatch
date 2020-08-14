require 'json'

ACK = {
  statusCode: 200,
  body: JSON.generate('OK')
}.freeze

def handler(event:, context:)
  puts '## Slackの情報'
  puts event.to_a

  # チャレンジ認証
  return { challenge: event['challenge'] } if event['challenge']

  # 200ステータスを返す
  ACK
end
