class Api::SchedulesController < ApiController
  before_filter :authenticate, only: %i(update destroy)
  before_filter :load, only: %i(update destroy)

  def index
    from = Date.today
    to = 2.months.from_now

    @schedules = Schedule.includes(:user).where(date: from..to).order(:date)
  end

  def update
    ActiveRecord::Base.transaction do
      existing = Schedule.find_by date: schedule_params[:date]

      if existing
        # swap the +user_id+s due to unique key constraint
        @schedule.update! user_id: existing.user_id
        existing.update! user_id: @session.user_id
      else
        # fill the schedule with the next user
        @schedule.update! user_id: nil

        # create new schedule for requested date
        current_user.schedules.create date: schedule_params[:date]
      end
    end
  rescue Exception => e
    puts e
    render_error 'Unable to update schedule', :internal_server_error
  end

  def destroy
    @schedule.update!(user_id: nil)
  end

  private

  def load
    @schedule = Schedule.find(params[:id])

    if @schedule.user_id != @session.user_id
      render_error 'You can only modify your own schedule', :unauthorized
    end
  end

  def schedule_params
    params.require(:schedule).permit(:date)
  end
end
