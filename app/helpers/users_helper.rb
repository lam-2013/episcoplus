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

  def more_active_users
    #più prolifici nel mese
    User.joins(:sermons).select("#{User.table_name}.*, count(#{Sermon.table_name}.id) as num_sermon")
    .where("#{Sermon.table_name}.created_at >= '#{(Time.now - 30.days).utc.iso8601}'").group("#{User.table_name}.id")
    .order("num_sermon DESC").limit(3)
  end

end
