class Users::InfosController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    user = User.first
    if user.update(user_params)
      redirect_to users_info_path, notice: "Account successfully updated!"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name)
    end
end
