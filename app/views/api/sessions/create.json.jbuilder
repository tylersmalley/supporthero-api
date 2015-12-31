json.user do
  json.(@user, :id, :name)
end

json.(@session, :access_token, :expires_in, :expires_at)
json.token_type "bearer"
