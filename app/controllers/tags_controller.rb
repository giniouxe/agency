class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @tags = Tag.all
    @articles = @tag.articles.paginate(page: params[:page], per_page: 10)
  end
end
