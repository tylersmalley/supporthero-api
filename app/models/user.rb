class User < ActiveRecord::Base
  has_many :schedules

  has_secure_password

  # Provides stats on the number of days each user has been
  # assigned as support hero
  #
  # Params:
  # +from+:: Date or Time object for when to start the report
  # +to+:: Date or Time object for when to end the report
  #
  # Returns ActiveRecord::Relation
  def self.stats from=1.month.ago, to: Date.today.advance(months: 1)
    select('users.id, COUNT(schedules.id) AS schedule_count')
      .joins(sanitize_sql_array(
        ['LEFT JOIN schedules ON schedules.user_id = users.id
            AND schedules.date BETWEEN ? AND ?',
         from.strftime('%Y-%m-%d'),
         to.strftime('%Y-%m-%d')
        ]
      ))
      .group('users.id')
      .order('COUNT(schedules.id)')
  end
end
