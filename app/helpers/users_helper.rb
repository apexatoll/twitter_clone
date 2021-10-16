module UsersHelper
  def avatar_for(user, options = { size:80 })
    size = options[:size]
    hash = Digest::MD5::hexdigest(user.email.downcase)
    url  = "https://secure.gravatar.com/avatar/#{hash}?s=#{size}"
    image_tag(url, alt:user.name, class:"avatar")
  end
end
