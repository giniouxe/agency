class CommentsController < ApplicationController
  before_action :logged_in_user, only: :destroy
  before_action :article_author, only: :destroy

  def create
    @comment = Comment.new(comment_params)
    @comment.article_id = params[:article_id]
    @comment.save
    redirect_to article_path(@comment.article)
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = 'Comment successfuly deleted.'
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:author, :body, :article_id)
    end

    def article_author
      @authored = current_user.articles.find_by(id: params[:article_id])
      redirect_to root_path if @authored.nil?
    end
end
