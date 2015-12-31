class ApiController < ApplicationController
  after_filter :cors_set_access_control_headers

  def authenticate
    auth_header = request.headers['Authorization']
    _, token = auth_header.split

    @session = Session.find token

    if !@session.valid?
      raise
    end
  rescue Exception => e
    puts e
    render_error 'Please login', :unauthorized
  end

  def current_user
    @current_user ||= User.find @session.user_id
  end

  def render_error message, status=:ok
    @error = { error: message }
    render 'api/error', status: status
  end

  def cors
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PATCH, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
    headers['Access-Control-Max-Age'] = '1728000'

    render :text => '', :content_type => 'text/plain'
  end

  private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PATCH, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end
end
