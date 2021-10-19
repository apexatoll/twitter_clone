class StaticPagesController < ApplicationController
  def home
    current_user.tap do |u|
      @micropost  = u.microposts.build if logged_in?
      @feed_items = u.feed.paginate(page:params[:page])
    end
  end
  def help
  end
  def about
  end
  def contact
  end
end
