class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :update, :destroy]
  before_action :correct_user, only: [:update, :destroy]

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:sucess] = 'Article published.'
      redirect_to user_path(current_user)
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def update
  end

  def destroy
    @article.destroy
    flash[:success] = 'Article successfuly deleted.'
    redirect_to request.referrer || root_url
  end

  private

    def article_params
      params.require(:article).permit(:title, :excerpt, :content)
    end

    def correct_user
      @article = current_user.articles.find_by(id: params[:id])
      redirect_to root_path if @article.nil?
    end
end
