json.user do
  json.(@user, :id, :name)
end

json.access_token @session.access_token
json.token_type "bearer"
