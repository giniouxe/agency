module PagesHelper

  # Returns full title per page.
  def full_title(page_title = '')
    base_title = 'Sample App'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
