json.extract! club, :id, :short_name, :name, :address, :city, :state, :zip, :phone, :par_in, :par_out, :tees, :created_at, :updated_at
json.url club_url(club, format: :json)
