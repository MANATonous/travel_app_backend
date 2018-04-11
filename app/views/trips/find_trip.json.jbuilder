json.array! @find_trip do |trip|
  json.id trip.id
  json.user_id trip.user_id
  json.title trip.title
  json.description trip.description
  json.city trip.city
  json.state trip.state
  json.country trip.country
  json.start_date trip.start_date
  json.end_date trip.end_date
  json.link trip.link
  json.photo asset_url(trip.photo.url(:med))
end

# Creates JSON object as instance variable for delivery to frontend as JSON, see controllers for more information
