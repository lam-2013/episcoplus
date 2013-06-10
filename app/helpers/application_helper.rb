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
end
