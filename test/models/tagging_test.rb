require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  def setup
    @user = Fabricate(:user,
                      name: 'Foobar', email: 'foobar@example.com',
                      password: 'foobar', password_confirmation: 'foobar',
                      activated: true, activated_at: Time.zone.now)
    @article = Fabricate.build(:article,
                               title: 'Lorem ipsum dolor sit amet.',
                               excerpt: 'Nam vel justo quis nisl.',
                               content: 'Nam tincidunt, neque non.',
                               user_id: @user.id, created_at: Time.zone.now,
                               tag_list: 'Foo')
  end

  test 'should be valid' do
    assert @article.taggings.first.valid?
  end

  test 'taggings should be destroyed when article is destroyed' do
    @article.save
    assert_difference 'Tagging.count', -1 do
      @article.destroy
    end
  end

  test 'taggings should be destroyed when tag is destroyed' do
    @article.save
    assert_difference 'Tagging.count', -1 do
      @article.tags.first.destroy
    end
  end
end
