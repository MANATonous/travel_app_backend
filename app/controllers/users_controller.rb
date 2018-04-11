class UsersController < ApplicationController

  # We might use it eventually?
  def index
    @users = User.all
  end

  # Get info from user, again not currently used, but may be used at some point
  def user_info
    @user = User.where("id = #{params[:user_id]}")
    # render json: user
  end

  # Create a new User from Register.js
  # we ran into errors when creating and using strong params alone, so we broke out each individual assignment
  def create
    # Set user attributes individually
    user = User.new()
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.email = params[:email]
    user.city = params[:city]
    user.state = params[:state]

    # Set user avatar to user submission, or default if blank
    # No current use for user avatar, eventual goal to display in trip page to see who is going.
    if params[:avatar_base]
      user.avatar = params[:avatar_base]
    else
      user.avatar = default_avatar
    end

    # save user and create user token for authentication
    if user.save
      token = Knock::AuthToken.new(payload: { sub: user.id }).token
      payload = {
        user: user,
        jwt: token
      }
      render json: payload, status: 201
    else
      render json: {errors: user.errors}, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :city, :state, :avatar_base)
  end

  # Sets default photo from internal files
  def default_avatar
    file_path = File.join(Rails.root, 'public', 'images', 'small', 'default_profile_image.png')
    base64_image = Base64.encode64(File.read(file_path))
    "data:image/jpg;base64,#{base64_image}"
  end

end
