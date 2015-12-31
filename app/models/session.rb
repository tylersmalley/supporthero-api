# Handling of ephemeral sessions without requiring a database
# lookup to validate.
#
# Tokens are an AES encrypted string consisting of the users
# +id+ and a custom epoch for which to expire.
#
# The epoch begins on January 1, 2015 which helps to reduce the
# size of the resulting token.

require 'aes'

EPOCH_OFFSET = 1420099200 # Jan 1, 2015

class Session
  include ActiveModel::Model

  attr_accessor :user_id, :expires_at
  attr_writer :token

  # Decrypts an +access_token+
  #
  # Returns Session instance
  def self.find token
    data = AES.decrypt(token, Rails.application.secrets.session_key)

    user_id, epoch = data.split(':')
    expires_at = Time.at(epoch.to_i + EPOCH_OFFSET)

    instance = allocate
    instance.send :initialize, user_id: user_id.to_i, expires_at: expires_at
    instance
  rescue
    raise InvalidSessionToken
  end

  # Provides an encrypted token with the +user_id+ and expiration
  def access_token
    expires = relative_epoch
    data = [self.user_id, expires.to_i].join(':')
    @access_token ||= AES.encrypt data, Rails.application.secrets.session_key
  end

  def valid?
    self.expires_at > Time.now
  end

  def expires_at
    @expires_at || Time.now.advance(hours: 1)
  end

  def expires_in
    (expires_at - Time.now).to_i
  end

  private

  def relative_epoch
    self.expires_at - EPOCH_OFFSET
  end
end

# Error classes
class InvalidSessionToken < Exception; end
