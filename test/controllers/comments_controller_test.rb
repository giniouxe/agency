require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @user = Fabricate(:user, name: 'Foobar', email: 'foobar@example.com',
                             password: 'foobar', activated: true,
                             activated_at: Time.zone.now)
    @article = Fabricate(:article, title: 'Lorem ipsum', excerpt: 'Si amet',
                                   content: 'Sed sit amet elementum elit.',
                                   user_id: @user.id)
    @comment = Fabricate(:comment, author: 'Foo', body: 'bar',
                                   article_id: @article.id)
  end

  test 'should create comment and redirect to article' do
    assert_difference 'Comment.count', + 1 do
      post :create, comment: { author: 'Lorem ipsum', body: 'Si amet' },
                    article_id: @article.id
    end
    assert_redirected_to article_path(@article)
  end

  test 'should delete comment and redirect to article' do
    log_in_as(@user, password: 'foobar')
    assert_difference 'Comment.count', - 1 do
      delete :destroy, article_id: @article.id, id: @comment
    end
    assert_redirected_to article_path(@article)
  end

  test 'should redirect destroy when user is not logged in' do
    assert_no_difference 'Comment.count' do
      delete :destroy, article_id: @article, id: @comment
    end
    assert_redirected_to login_path
  end

  test 'should redirect destroy for wrong user' do
    wrong_user = Fabricate(:user, name: 'Wrong', email: 'wrong@example.com',
                                  password: 'notgood', activated: true,
                                  activated_at: Time.zone.now)
    log_in_as(wrong_user, password: 'notgood')
    assert_no_difference 'Comment.count' do
      delete :destroy, article_id: @article, id: @comment
    end
    assert_redirected_to root_path
  end
end
