module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  def current_user
    if(id = session[:user_id])
      @current_user ||= find_user_by_id id
    elsif(id = cookies.encrypted[:user_id])
      user = find_user_by_id id
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  def logged_in?
    !current_user.nil?
  end
  private
  def find_user_by_id(id)
    User.find_by(id:id)
  end
end
