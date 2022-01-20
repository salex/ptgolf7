json.extract! player, :id, :group_id, :name, :first_name, :last_name, :nickname, :use_nickname, :tee, :quota, :rquota, :phone, :last_played, :is_frozen, :created_at, :updated_at
json.url player_url(player, format: :json)
