module ApplicationHelper
  # Returns full title per page.
  def full_title(page_title = '')
    base_title = 'Solicom | Agence de communication'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
