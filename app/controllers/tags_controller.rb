class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @tags = Tag.all
    @articles = @tag.articles
  end
end
