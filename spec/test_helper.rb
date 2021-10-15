module TestHelper
  def is_logged_in?
    !session[:user_id].nil?
  end
  def log_in_as(user, password="password")
    post login_path, params:{
      session:{
        email:user.email,
        password:password,
        remember_me:'1'
      }
    }
  end
end
