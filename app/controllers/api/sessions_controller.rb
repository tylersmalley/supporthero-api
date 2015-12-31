class Api::SessionsController < ApiController
  protect_from_forgery with: :null_session

  before_filter :authenticate, only: [:show]

  def create
    @user = User.find_by(name: params[:name])

    if !@user.try(:authenticate, params[:password])
      @error = { message: 'Invalid credentials' }
      render 'api/error', status: :unauthorized
    end

    @session = Session.new user_id: @user.id
  end

  def show
  end
end
