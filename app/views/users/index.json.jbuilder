json.array! @users do |user|
  json.first_name user.first_name
  json.last_name user.last_name
  json.email user.email
  json.city user.city
  json.state user.state
  json.avatar asset_url(user.avatar.url(:small))
end

# Creates JSON object as instance variable for delivery to frontend as JSON, see controllers for more information
