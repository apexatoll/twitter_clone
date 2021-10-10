module UsersHelper
  def avatar_for(user)
    hash = Digest::MD5::hexdigest(user.email.downcase)
    url  = "https://secure.gravatar.com/avatar/#{hash}"
    image_tag(url, alt:user.name, class:"avatar")
  end
end
