require 'digest/md5'

module UsersHelper
  def gravatar_for(user, options = { size: 80, html_class: 'gravatar' })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    html_class = options[:html_class]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: html_class)
  end
end
