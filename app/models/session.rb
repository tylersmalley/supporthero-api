require 'aes'

EPOCH_OFFSET = 1420099200 # Jan 1, 2015

class InvalidSessionToken < Exception; end

class Session
  include ActiveModel::Model

  attr_accessor :user_id, :expires_at
  attr_writer :token, :ttl

  def self.find token
    data = AES.decrypt(token, Rails.application.secrets.session_key)

    user_id, epoch = data.split(':')
    expires_at = Time.at(epoch.to_i + EPOCH_OFFSET)

    instance = allocate
    instance.send :initialize, user_id: user_id, expires_at: expires_at
    instance
  rescue
    raise InvalidSessionToken
  end

  def access_token
    data = [self.user_id, (relative_epoch + self.ttl).to_i].join(':')
    @access_token ||= AES.encrypt data, Rails.application.secrets.session_key
  end

  def ttl
    @ttl || 1.hour
  end

  def valid?
    self.expires_at > Time.now
  end

  private

  def relative_epoch time=Time.now
    time - EPOCH_OFFSET # Jan 1, 2015
  end
end
