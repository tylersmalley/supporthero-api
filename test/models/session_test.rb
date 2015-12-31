require 'test_helper'
require 'session'

class SessionTest < ActiveSupport::TestCase
  test 'creates a token' do
    session = Session.new user_id: 1

    assert session.access_token.is_a? String
  end

  test 'finding a token' do
    token = Session.new(user_id: 1).access_token
    session = Session.find(token)

    assert session.valid?
    assert session.user_id == 1
    assert session.expires_at.to_i == Time.now.advance(hours: 1).to_i
    assert_instance_of Session, session
  end

  test 'finding a token with custom expiration' do
    expires = Time.now.advance(hours: 2)
    token = Session.new(user_id: 1, expires_at: expires).access_token
    session = Session.find(token)

    assert session.valid?
    assert session.user_id == 1
    assert session.expires_at.to_i == expires.to_i
    assert_instance_of Session, session
  end

  test 'finding an expired token' do
    token = Session.new(user_id: 1).access_token

    Timecop.travel(2.hours.from_now) do
      session = Session.find(token)
      assert_not session.valid?
    end
  end

  test 'invalid token raising an exception' do
    assert_raises InvalidSessionToken do
      Session.find 'BADTOKEN'
    end
  end
end
