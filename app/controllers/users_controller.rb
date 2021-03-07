class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to root_path unless current_user&.admin?
    @user = User.new
    @users = User.all
  end

  def create
    redirect_to root_path unless current_user&.admin?
    user = User.new(user_params)
    if user.save
      # display success
      flash[:notice] = "User was successfully created."
    else
      # display error
      flash[:alert] = "User was not created. Errors: " + user.errors.full_messages.join(',')
    end
    redirect_to add_users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
