json.extract! user, :id, :group_id, :player_id, :email, :username, :role, :reset_token, :created_at, :updated_at
json.url user_url(user, format: :json)
