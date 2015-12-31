json.array! @schedules do |schedule|
  json.(schedule, :id, :user_id, :date)

  json.user do
    json.(schedule.user, :name)
  end
end
