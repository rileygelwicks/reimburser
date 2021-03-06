class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to user_path(current_user)
    end
    # @transaction = Transaction.find(params[:id])
    @transaction = Transaction.where(:user_id => params[:id])
  end

  def edit
    if user_signed_in?
      user_signed_in=true
    else
      user_signed_in=false
    end
    id = params[:id]
    @user = User.find(id)
  end

  def update
    id = params[:id]
    user = User.find(id)

    updated_attributes = params.require(:user).permit(:email, :password, :password_confirmation)
    user.update_attributes(updated_attributes)
    redirect_to user
  end

end
