require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @user = Fabricate(:user, name: 'Foobar', email: 'foobar@example.com',
                             password: 'foobar', activated: true,
                             activated_at: Time.zone.now)
    @article = Fabricate(:article, title: 'Lorem ipsum', excerpt: 'Si amet',
                                   content: 'Sed sit amet elementum elit.',
                                   user_id: @user.id)
    @other_user = Fabricate(:user, name: 'Fizzbuzz', email: 'fizz@example.com',
                                   password: 'fizzbuzz', activated: true,
                                   activated_at: Time.zone.now)
    @wrong_article = Fabricate(:article, title: 'Foo bar', excerpt: 'Si amet',
                                         content: 'Sed sit amet elementum.',
                                         user_id: @other_user.id)
  end

  test 'should redirect create when user not logged in' do
    assert_no_difference 'Article.count' do
      post :create, article: { title: 'Lorem ipsum', excerpt: 'Si amet',
                               content: 'Sed sit amet elementum elit.' }
    end
    assert_redirected_to login_path
  end

  test 'should create article when user logged in' do
    log_in_as(@user, password: 'foobar')
    assert_difference 'Article.count', + 1 do
      post :create, article: { title: 'Fizzbuzz', excerpt: 'Si amet',
                               content: 'Sed sit amet elementum elit.' }
    end
    assert_redirected_to user_path(@user)
  end

  test 'should redirect edit when user not logged in' do
    post :update, id: @article, article: { title: 'Foobar', excerpt: 'Si amet.',
                                           content: 'Sed sit amet elementum.' }
    assert_redirected_to login_path
  end

  test 'should get edit when author is logged in' do
    log_in_as(@user, password: 'foobar')
    get :edit, id: @article
    assert :success
  end

  test 'should update article when author is logged in' do
    log_in_as(@user, password: 'foobar')
    post :update, id: @article, article: { title: 'Foobar', excerpt: 'Si amet',
                                           content: 'Sed sit amet elementum.' }
    @article.reload
    assert_equal 'Foobar', @article.title
    assert_redirected_to article_path(@article)
  end

  test 'should redirect edit for wrong article' do
    log_in_as(@user, password: 'foobar')
    get :edit, id: @wrong_article
    assert_redirected_to root_url
  end

  test 'should redirect destroy when user not logged in' do
    assert_no_difference 'Article.count' do
      delete :destroy, id: @article
    end
    assert_redirected_to login_path
  end

  test 'should redirect destroy for wrong article' do
    log_in_as(@user, password: 'foobar')
    assert_no_difference 'Article.count' do
      delete :destroy, id: @wrong_article
    end
    assert_redirected_to root_url
  end

  test 'should destroy article when author logged in' do
    log_in_as(@user, password: 'foobar')
    assert_difference 'Article.count', - 1 do
      delete :destroy, id: @article
    end
    assert_redirected_to root_url
  end
end
