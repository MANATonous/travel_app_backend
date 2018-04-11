class TripsController < ApplicationController

  # Returns an array of all trips belonging to a user, returns it to Dashboard.js
  def trips_by_user
    @trips_by_user = User.find(params[:user_id]).trips
  end

  # Returns a Trip to Trip.js component
  def find_trip
    @find_trip = Trip.where("id = #{params[:trip_id]}")
  end

  # Generates trip code for inviting people, called by create method
  def generate_code(number)
    charset = Array('A'..'Z') + Array(0..9)
    Array.new(number) { charset.sample }.join
  end

  # Creates a trip from NewTrip.js component in Dashboard.js
  def create
    trip = Trip.new(trip_params)
    trip.rand_code = generate_code(6)

    # checks to see if photo was sent, and assigns default if none sent
    if params[:photo_base]
      trip.photo = params[:photo_base]
    else
      trip.photo = default_photo
    end

    trip.save!

    # creates a UserTrip object as a reference between Users and Trips
    tripid = Trip.last.id
    userid = params[:user_id]
    UserTrip.create(user_id: userid, trip_id: tripid)
    render json: trip
  end

  # From JoinTrip.js allows user to send code and be added to trip
  def join
    user = User.find_by_id(params[:user_id])
    code = params[:code].to_s

    # if code matches a trip code in db, create UserTrip item, otherwise, return error code
    if trip = Trip.find_by_rand_code(code)
      ut = UserTrip.new()
      ut.user_id = user.id
      ut.trip_id = trip.id
      ut.save!
      render json: trip, status: 201
    else
      render json: {errors: user.errors}, status: 404
    end
  end

  # From UpdateTrip.js allows user to change any element of their trip
  def update
    trip = Trip.find_by_id(params[:trip_id])
    trip.title = params[:title]
    trip.city = params[:city]
    trip.state = params[:state]
    trip.country = params[:country]
    trip.start_date = params[:start_date]
    trip.end_date = params[:end_date]
    trip.description = params[:description]
    trip.link = params[:link]
    if params[:photo_base]
      trip.photo = params[:photo_base]
    end
    trip.save!
    render json: trip
  end

  private

  def trip_params
    params.require(:trip).permit(:title, :city, :state, :country, :start_date, :end_date, :description, :link, :rand_code, :user_id, :photo_base)
  end

  # Sets default photo from internal files
  def default_photo
    file_path = File.join(Rails.root, 'public', 'images', 'small', 'trip_default_image.png')
    base64_image = Base64.encode64(File.read(file_path))
    "data:image/jpg;base64,#{base64_image}"
  end

end
