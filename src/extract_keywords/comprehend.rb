require 'aws-sdk'
require_relative 'private_methods'

def handler(event:, context:)
  puts '## キーワード抽出'

  # textがなかったら空で返す
  text = event['text']
  return response_with_keywords([]) if text.empty?

  puts '## 質問原文'
  puts text

  # キーワード抽出
  client   = Aws::Comprehend::Client.new
  resp     = client.detect_key_phrases({ text: text, language_code: 'ja' })
  keywords = resp.key_phrases.map(&:text).uniq

  # 抽出したキーワードをjsonで返す
  response_with_keywords(keywords)
end
