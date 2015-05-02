require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = Fabricate(:user,
                      name: 'Foobar', email: 'foobar@example.com',
                      password: 'foobar', password_confirmation: 'foobar',
                      activated: true, activated_at: Time.zone.now)
    @article = Fabricate(:article,
                         title: 'Lorem ipsum dolor sit amet.',
                         excerpt: 'Nam vel justo quis nisl.',
                         content: 'Nam tincidunt, neque non.',
                         user_id: @user.id, created_at: Time.zone.now)
    @comment = Fabricate.build(:comment, author: 'Fizz', body: 'Lorem ipsum',
                                         article_id: @article.id)
  end

  test 'should be valid' do
    assert @comment.valid?
  end

  test 'should have article id' do
    @comment.article_id = nil
    assert_not @comment.valid?
  end

  test 'author should be present' do
    @comment.author = '       '
    assert_not @comment.valid?
  end

  test 'body should be present' do
    @comment.body = '           '
    assert_not @comment.valid?
  end

  test 'author length should not be too long' do
    @comment.author = 'a' * 200
    assert_not @comment.valid?
  end

  test 'body length should not be too long' do
    @comment.body = 'a' * 600
    assert_not @comment.valid?
  end

  test 'comment should be destroyed when article is destroyed' do
    @comment.save
    assert_difference 'Comment.count', -1 do
      @article.destroy
    end
  end
end
