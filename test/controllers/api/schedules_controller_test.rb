require 'test_helper'

class Api::SchedulesControllerTest < ActionController::TestCase
  fixtures :schedules, :users

  test 'index includes schedules' do
    get :index, format: :json

    assert json_response.count == 40, 'has 40 elements'
  end

  test 'index including correct schedule data' do
    get :index, format: :json
    schedule = json_response.first
    user = schedule['user']

    assert schedule['id'] == 1, 'correct id'
    assert schedule['user_id'] == 1, 'correct user_id'
    assert schedule['date'] == '2015-12-31', 'correct date'
    assert user['name'] == 'Sherry', 'correct name'
  end

  test 'swapping schedule with another user' do
    existing = Schedule.find_by date: '2016-01-05'

    login_user 1
    post :update, { id: 1, schedule: { date: existing.date }, format: :json }

    assert json_response['user_id'] == existing.id
    assert json_response['date'] == '2015-12-31'
    assert json_response['user']['name'] == existing.user.name
  end

  test 'changing to unassigned date' do
    login_user 1
    post :update, { id: 1, schedule: { date: '2017-05-22' }, format: :json }

    assert_not json_response['user_id'] == 1, 'no longer user 1'
    assert json_response['date'] == '2015-12-31'
    assert_not json_response['user']['name'] == 'no longer Sherry'

    # requested schedule
    schedule = Schedule.find_by date: '2017-05-22'
    assert schedule.user_id == 1
  end

  test 'deleting a schedule' do
    login_user 1

    delete :destroy, { id: 1, format: :json }
    assert_not json_response['user_id'] == 1, 'no longer user 1'
  end
end
