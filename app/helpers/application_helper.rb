module ApplicationHelper
  # Returns full title per page.
  def full_title(page_title = '')
    base_title = "Agency | Let's communicate!"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
