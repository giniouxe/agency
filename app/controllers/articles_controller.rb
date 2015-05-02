class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

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

  def show
    @article = Article.find(params[:id])
    @author = @article.user
    @comments = @article.comments.paginate(page: params[:page], per_page: 10)
  end

  def edit
    @article = current_user.articles.find(params[:id])
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    render 'pages/home'
  end

  def update
    if @article.update(article_params)
      flash[:success] = 'Your article has been updated.'
      redirect_to @article
    else
      @feed_items = current_user.feed.paginate(page: params[:page],
                                               per_page: 10)
      render 'pages/home'
    end
  end

  def destroy
    @article.destroy
    flash[:success] = 'Article successfuly deleted.'
    redirect_to request.referrer || root_url
  end

  private

    def article_params
      params.require(:article).permit(:title, :excerpt, :content, :tag_list, :picture)
    end

    def correct_user
      @article = current_user.articles.find_by(id: params[:id])
      redirect_to root_path if @article.nil?
    end
end
