module ApplicationHelper

  # Return a title on a per-page basis
  def full_title(page_title)
    base_title = 'episco+'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  # Return welcome page
  def welcome?(isWelcome)
    if isWelcome.empty?
      false
    else
      isWelcome
    end
  end

  def pluralize_without_count(count, noun, text = nil)
    if count == 1
      noun
    else
      text.nil? ? noun.pluralize : text
    end
  end

  def pluralize_other_friends(count)
    other = pluralize_without_count(count, 'un altro', 'altri')
    x = (count == 1) ? '' : count

    "#{other} #{x}".strip
  end

  def generate_tag_cloud
    top_tags = "SELECT tag_id FROM taggings WHERE created_at >= '#{(Time.now - 30.days).utc.iso8601}' GROUP BY tag_id ORDER BY COUNT(*) DESC LIMIT 30"
    Sermon.unscoped.tag_counts.where("id in(#{top_tags})").order('name ASC, count DESC')
  end
end
