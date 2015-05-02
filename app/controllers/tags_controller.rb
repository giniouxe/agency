class TagsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  def show
    @tag = Tag.find(params[:id])
    @tags = Tag.all
    @articles = @tag.articles.paginate(page: params[:page], per_page: 10)
  end

  def edit
    @tag = Tag.find(params[:id])
    render 'tags/edit'
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      flash[:success] = 'Tag sucessfully updated.'
      redirect_to root_path
    else
      render 'tags/edit'
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash[:success] = 'Tag deleted.'
    redirect_to root_path
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end
