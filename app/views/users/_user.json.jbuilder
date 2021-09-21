json.extract! user, :id, :email, :name, :address, :postal_code,:created_at, :pass,:updated_at
json.url user_url(user, format: :json)
