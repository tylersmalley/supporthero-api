require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'creates a token' do
    session = Session.new user_id: 1
    assert session.access_token.is_a? String
  end

  test 'finds a valid token' do
    token = Session.new(user_id: 1).access_token
    session = Session.find(token)
    assert session.valid?
  end

  test 'finds an expired token' do
    token = Session.new(user_id: 1).access_token
    Timecop.travel(2.hours.from_now) do
      session = Session.find(token)
      assert !session.valid?
    end
  end

  test 'invalid token raises exception' do
    assert_raises InvalidSessionToken do
      Session.find 'BADTOKEN'
    end
  end
end
