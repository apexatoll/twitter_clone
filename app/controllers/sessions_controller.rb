class SessionsController < ApplicationController
  def new
  end
  def create
    if valid_credentials?
      #log the user in and redirect to user's show page
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  private
  def find_user
    @user ||= User.find_by(email:params[:session][:email].downcase)
  end
  def valid_credentials?
    find_user && correct_password?
  end
  def correct_password?
    @user.authenticate(params[:session][:password])
  end
end
