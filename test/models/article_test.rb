require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = Fabricate(:user, name: 'Foobar', email: 'foobar@example.com',
                             password: 'foobar',
                             password_confirmation: 'foobar', activated: true,
                             activated_at: Time.zone.now)
    @article = Fabricate.build(:article, title: 'Lorem ipsum dolor sit amet.',
                                         excerpt: 'Nam vel justo quis nisl.',
                                         content: 'Nam tincidunt, neque non.',
                                         user_id: @user.id,
                                         created_at: Time.zone.now)
  end

  test 'should be valid' do
    assert @article.valid?
  end

  test 'article should have user id' do
    @article.user_id = nil
    assert_not @article.valid?
  end

  test 'title should be present' do
    @article.title = '      '
    assert_not @article.valid?
  end

  test 'excerpt should be present' do
    @article.excerpt = '      '
    assert_not @article.valid?
  end

  test 'excerpt should have maximum length of 350' do
    @article.excerpt = 'a' * 500
    assert_not @article.valid?
  end

  test 'content should be present' do
    @article.content = '     '
    assert_not @article.valid?
  end

  test 'article can have tags' do
    @article.tag_list = 'foo, bar'
    assert @article.valid?
  end

  test 'tags should be titleized' do
    @article.tag_list = 'foo, bar'
    @article.save!
    assert_equal 'Foo, Bar', @article.tag_list
  end

  test 'order should be most recent first' do
    id = @user.id
    most_recent = Fabricate(:article, title: 'Lorem ipsum dolor sit amet.',
                                      excerpt: 'Nam vel justo quis nisl.',
                                      content: 'Nam tincidunt, neque non.',
                                      user_id: id,
                                      created_at: Time.zone.now)
    Fabricate.times(4, :article) do
      title { Faker::Lorem.sentence }
      excerpt { Faker::Lorem.paragraph }
      content { Faker::Lorem.paragraph(3) }
      created_at { Faker::Time.between(3.years.ago, 1.years.ago) }
      user_id id
    end
    assert_equal Article.first, most_recent
  end

  test 'articles should be destroyed when user is destroyed' do
    @user.save
    @user.articles.create!(title: 'Lorem ipsum dolor sit amet.',
                           excerpt: 'Nam vel justo quis nisl.',
                           content: 'Nam tincidunt, neque non.',
                           user_id: @user.id)
    assert_difference 'Article.count', -1 do
      @user.destroy
    end
  end
end
