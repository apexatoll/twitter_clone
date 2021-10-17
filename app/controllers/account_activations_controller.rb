class AccountActivationsController < ApplicationController
  def edit
    if authentication_success?
      @user.activate
      log_in @user
      flash[:success] = "Account activated!"
      redirect_to @user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
  private
  def authentication_success?
    find_user
    @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
  end
  def find_user
    @user ||= User.find_by(email:params[:email])
  end
end
