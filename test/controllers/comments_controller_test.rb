require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @user = Fabricate(:user, name: 'Foobar', email: 'foobar@example.com',
                             password: 'foobar', activated: true,
                             activated_at: Time.zone.now)
    @article = Fabricate(:article, title: 'Lorem ipsum', excerpt: 'Si amet',
                                   content: 'Sed sit amet elementum elit.',
                                   user_id: @user.id)
  end

  test 'should create comment and redirect to article' do
    assert_difference 'Comment.count', + 1 do
      post :create, comment: { author: 'Lorem ipsum', body: 'Si amet' },
                    article_id: @article.id
    end
    assert_redirected_to article_path(@article)
  end
end
