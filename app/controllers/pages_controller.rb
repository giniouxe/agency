class PagesController < ApplicationController
  def home
    if logged_in?
      @article = current_user.articles.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
  end

  def contact
  end
end
