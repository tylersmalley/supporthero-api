require 'yaml'

namespace :update_fixtures do
  desc "Updates the users fixture from the database"
  task users: :environment do
    users = User.all

    data = users.inject({}) do |fixture, u|
      password = "#{u.name.downcase}123"
      fixture[u.name] = {
        'id' => u.id,
        'name' => u.name,
        'password_digest' => BCrypt::Password.create(password, cost: 4)
      }

      fixture
    end

    write 'users', data
  end

  desc "Updates the schedules fixture from the database"
  task schedules: :environment do
    schedules = Schedule.all

    data = schedules.inject({}) do |fixture, s|
      fixture[s.date] = {
        'id' => s.id,
        'date' => s.date,
        'user_id' => s.user_id
      }

      fixture
    end

    write 'schedules', data
  end

  def write name, data
    File.open("test/fixtures/#{name}.yml", 'w') do |file|
      file.write data.to_yaml
    end
  end
end

