require 'base64'
require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'

module PushReceiver
  extend ActiveSupport::Concern

  included do
    # The endpoint URL for pushing notifications to this device.
    validates :push_url, length: { in: 1..256, allow_nil: true }
  end

  # Server signature for the push device ID.
  def push_token
    digest = OpenSSL::Digest.new 'sha256'
    hmac_key = Rails.application.secrets.w3gram_secret
    hmac = OpenSSL::HMAC.digest digest, hmac_key, "device-id|#{key}"
    token = Base64.urlsafe_encode64 hmac
    token.strip!
    token.gsub! '=', ''
    token
  end

  # Push a notification to this device.
  #
  # @param {Hash} data JSON-compatible notification data
  def push_message(data)
    return false unless push_url

    uri = URI.parse push_url
    request = Net::HTTP::Post.new uri.path,
                                  'Content-Type' => 'application/json'
    request.body = { message: data }.to_json
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true if uri.scheme == 'https'
    begin
      http.request request
    rescue SocketError => e
      # Network error.
      Rails.logger.error e
      false
    end
  end
end
