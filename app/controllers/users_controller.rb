class UsersController < ApplicationController
  before_action :authenticate_user!

  # Scopes
  has_scope :by_id
  has_scope :by_name
  has_scope :by_role

  def index
    redirect_to root_path unless current_user&.admin?
    @users = apply_scopes(User).order(created_at: :desc).all
  end

  def add_user
    @user = User.new
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
    redirect_to manage_users_path
  end

  def profile
    @user = current_user
  end

  def update_profile
    update_params = user_params.to_h
    update_params.delete('password') if update_params['password'].blank?
    update_params.delete('password_confirmation') if update_params['password_confirmation'].blank?

    if current_user.update(update_params)
      # display success
      flash[:notice] = "Date was successfully updated."
    else
      # display error
      flash.now[:alert] = "Date was not updated. Errors: " + current_user.errors.full_messages.join(',')
    end
    redirect_to user_profile_path
  end

  def delete_user
    User.find(params[:id]).destroy!
    redirect_to manage_users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
