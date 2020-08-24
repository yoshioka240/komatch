require 'layer_constants'
require 'layer_methods'
Dir[File.dirname(__FILE__) + '/require_files/*.rb'].sort.each { |file| require file }

def handler(event:, context:)
  p '## Slackの情報'
  p event

  # Slackからx-www-form-urlencoded形式で来たbodyの成形
  body = converted_body(event['body'])
  if body
    p '## Interactivity Body'
    p body
  end

  # チャレンジ認証
  challenge_authentication(event['challenge'])

  # Slack AppのHomeタブの初期表示処理
  display_home(event['event'])

  # 相談概要投稿フォームモーダルの表示処理
  render_question_post_modal(body)

  # 相談概要投稿受信処理
  recieve_question_post(body)

  # 200ステータスを返す
  ACK
end
