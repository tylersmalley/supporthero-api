ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...

  # Freeze time to our fixtures
  Timecop.freeze Time.new(2015, 12, 31, 1, 2, 3)

  def json_response
    JSON.parse response.body
  end

  # Sets bearer token for the user
  def login_user user_id
    token = Session.new(user_id: user_id).access_token
    @request.headers['Authorization'] = "Bearer #{token}"
  end
end
