require 'cgi'
require 'uri'
require 'json'

# チャレンジ認証
def challenge_authentication(challenge)
  return unless challenge

  { challenge: challenge }
end

# Slackからx-www-form-urlencoded形式で来たbodyの成形
def converted_body(body_str)
  return unless body_str

  unescaped_body = CGI.unescape(body_str)
  decoded_body = URI.decode_www_form(unescaped_body)
  JSON.parse(decoded_body[0][1])
end
