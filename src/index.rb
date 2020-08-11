require 'json'

ACK = {
  statusCode: 200,
  body: JSON.generate('OK')
}.freeze

def handler(event:, context:)
    return { challenge: event['challenge'] } if event['challenge']

    ACK
end

