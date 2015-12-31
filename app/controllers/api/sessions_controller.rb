class Api::SessionsController < ApiController
  before_filter :authenticate, only: %i(show)

  def create
    @user = User.find_by(name: params[:name])

    if !@user.try(:authenticate, params[:password])
      return render_error 'Invalid credentials', :unauthorized
    end

    @session = Session.new(user_id: @user.id)
  end

  def show
  end
end
