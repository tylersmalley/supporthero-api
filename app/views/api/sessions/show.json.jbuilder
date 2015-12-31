json.user do
  json.id @session.user_id
end

json.access_token @session.access_token
json.token_type "bearer"
