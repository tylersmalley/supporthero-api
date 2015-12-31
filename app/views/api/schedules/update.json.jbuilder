json.(@schedule, :id, :user_id, :date)

json.user do
  json.name @schedule.user.name
end
