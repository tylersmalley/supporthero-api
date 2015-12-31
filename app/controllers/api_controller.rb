class ApiController < ApplicationController
  def authenticate
    auth_header = request.headers['Authorization']
    _, token = auth_header.split

    @session = Session.find token

    if !@session.valid?
      raise
    end
  rescue Exception => _
    @error = { message: 'Please login' }
    render 'api/error', status: :unauthorized
  end
end
