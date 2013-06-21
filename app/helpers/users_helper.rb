module UsersHelper

  # Return the Gravatar (http://gravatar.com) for a given user
  def gravatar_for(user, options = {size: 50})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", height: "#{size}", width: "#{size}", style: "border-width:#{size/20}px")
  end

  def suggested_user
    User.getSuggestedUsers(current_user);
  end

end
