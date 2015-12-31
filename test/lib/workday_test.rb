require 'test_helper'
require 'workday'

DEC_31    = Date.new 2015, 12, 31
HOLIDAY   = Date.new 2016, 1, 1
MONDAY    = Date.new 2016, 1, 4
TUESDAY   = Date.new 2016, 1, 5
WEDNESDAY = Date.new 2016, 1, 6
THURSDAY  = Date.new 2016, 1, 7
FRIDAY    = Date.new 2016, 1, 8
SATURDAY  = Date.new 2016, 1, 9
SUNDAY    = Date.new 2016, 1, 10

class WorkdayTest < ActiveSupport::TestCase
  test 'is initializable' do
    workday = Workday.new MONDAY

    assert workday.date == MONDAY
    assert_instance_of Workday, workday
  end

  test 'date falling on a weekend' do
    [MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY].each do |day|
      workday = Workday.new day

      assert workday.working?
      assert_not workday.weekend?
    end

    [SATURDAY, SUNDAY].each do |day|
      workday = Workday.new day

      assert workday.weekend?
      assert_not workday.working?
    end
  end

  test 'date falling on a holiday' do
    workday = Workday.new HOLIDAY
    assert workday.holiday?
  end

  test 'name of holiday' do
    workday = Workday.new HOLIDAY
    assert workday.holiday == 'New Year\'s Day'
  end

  test 'progressing to next day' do
    workday = Workday.new HOLIDAY
    workday.next!

    assert workday.date = HOLIDAY + 1.day
  end

  test 'next working date from a Friday' do
    workday = Workday.new FRIDAY
    workday.next_working!

    assert workday.date == Date.new(2016, 1, 11)
  end

  test 'next working date before holiday' do
    workday = Workday.new DEC_31
    workday.next_working!

    assert workday.date == MONDAY
  end
end
