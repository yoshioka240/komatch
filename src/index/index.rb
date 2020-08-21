require 'aws-sdk'
require 'json'
require 'net/http'
require 'uri'
require 'constants'
require 'private_methods'

def handler(event:, _context:)
  puts '## Slackの情報'
  puts event.to_a

  # チャレンジ認証
  return { challenge: event['challenge'] } if event['challenge']

  # Slack AppのHomeタブの初期表示処理
  display_home(event['event']['user']) if event['event']['type'].to_s == 'app_home_opened'

  # 200ステータスを返す
  ACK
end
