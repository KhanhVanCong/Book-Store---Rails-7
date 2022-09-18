class Users::InfosController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    if current_user.update(user_params)
      flash.now[:notice] = "Account successfully updated!"
      # render :show, status: :ok
      # redirect_to users_info_path, notice: "Account successfully updated!"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def get_change_password
  end
  def change_password
    if current_user.update_with_password(password_params)
      redirect_to login_path, notice: "Your Password has been updated!"
    else
      render "users/infos/get_change_password"
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation, :current_password)
    end
end
