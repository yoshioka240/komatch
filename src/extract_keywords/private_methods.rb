private

def response_with_keywords(keywords)
  puts '## 抽出したキーワード'
  puts keywords.join(', ')
  { keywords: keywords }.to_json
end
