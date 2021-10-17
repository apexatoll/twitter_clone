class SessionsController < ApplicationController
  def new
  end
  def create
    if valid_credentials?
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        handle_remember_me
        log_in @user
        redirect_to forwarding_url || @user
      else
        flash[:warning] = "Account not activated.\nCheck your email for the activation link."
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  def destroy
    log_out if logged_in?
    redirect_to root_url
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
  def handle_remember_me
    params[:session][:remember_me] == '1' ?
      remember(@user) :
      forget(@user)
  end
end
