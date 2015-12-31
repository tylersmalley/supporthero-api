require 'test_helper'

class Api::SessionsControllerTest < ActionController::TestCase
  fixtures :users

  test "should log in" do
    post :create, { name: 'Sherry', password: 'sherry123', format: :json }
    json = json_response

    assert_response :success
    assert json['expires_in'] == 1.hour, 'expires in an hour'
    assert json['access_token'].length, 'has an access token'
    assert json['user']['name'] == 'Sherry', 'has users name'
  end

  test 'loggin in provides valid bearer token' do
    post :create, { name: 'Sherry', password: 'sherry123', format: :json }
    token = json_response['access_token']

    assert Session.find(token).valid?
  end

  test 'invalid login attempt' do
    post :create, { name: 'Sherry', password: 'wrongpw', format: :json }
    json = json_response

    assert_response :unauthorized
    assert json.has_key? 'message'
  end

end
