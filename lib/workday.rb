# Workday
#
# Provides helpers to determine if a day is workable based on if it
# falls on a weekend or a California holiday.
#
# TODO: Generally, if a holiday falls on a Saturday it will be observed
# on the previous Friday. If it falls on a Sunday, it's observed on the
# following Monday

class Workday
  attr_accessor :date

  def initialize date
    @date = date
  end

  def weekend?
    date.saturday? || date.sunday?
  end

  def holidays
    {
      '01/01' => 'New Year\'s Day',
      '01/18' => 'Martin Luther King Jr. Day',
      '02/15' => 'Presidents\' Day',
      '03/31' => 'Cesar Chavez Day',
      '05/30' => 'Memorial Day',
      '07/04' => 'Independence Day',
      '09/05' => 'Labor Day',
      '11/11' => 'Veterans Day',
      '11/24' => 'Thanksgiving Day',
      '11/25' => 'Day after Thansgiving',
      '12/25' => 'Christmas Day'
    }
  end

  # If the +date+ falls on a holiday, this method returns
  # the name of the holday
  def holiday
    holidays[date.strftime('%m/%d')]
  end

  def holiday?
    holiday.present?
  end

  def working?
    !holiday? && !weekend?
  end

  # Progresses +date+ to following day
  def next!
    self.date += 1
  end

  # Progreses +date+ to the following working day
  def next_working!
    next!

    while !working?
      next!
    end

    self
  end
end
