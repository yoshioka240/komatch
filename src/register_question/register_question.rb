require 'securerandom'
require 'layer_constants'
require 'layer_methods'

def handler(event:, context:)
  # Featureは配列が入るので処理を分けている
  string_attrs = { UserId: event['user_id'], Body: event['body'] }
  array_attrs = { Feature: event['feature_tag'] }
  id = SecureRandom.alphanumeric(10)

  string_attrs.each do |data_type, data_value|
    put_item(id, data_type, data_value)
  end

  array_attrs.each do |data_type, data_value|
    data_value.each do |value|
      put_item(id, data_type.to_s + '_' + value, value)
    end
  end

  # 200ステータスを返す
  ACK
end
