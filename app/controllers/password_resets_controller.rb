class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Please check your emails for reset password link.'
      redirect_to root_path
    else
      flash[:danger] = 'Email adress not found.'
      render 'new'
    end
  end

  def edit
  end
end
