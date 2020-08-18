require 'aws-sdk'

def handler(event:, _context:)
  client = Aws::Comprehend::Client.new
  resp   = client.detect_key_phrases({ text: event['text'], language_code: 'ja' })

  { keywords: resp.key_phrases.map(&:text).uniq }.to_json
end
