require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = Fabricate(:user,
                      name: 'Charlie', email: 'charlie@example.com',
                      password: 'croquettes', activated: true,
                      activated_at: Time.zone.now)
  end

  test 'display published articles' do
    user_id = @user.id
    Fabricate.times(31, :article) do
      title { Faker::Lorem.sentence }
      excerpt { Faker::Lorem.paragraph }
      content { Faker::Lorem.paragraph(3) }
      user_id user_id
      created_at 3.days.ago
    end

    log_in_as(@user, password: 'croquettes')
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.articles.count.to_s, response.body
    assert_select 'div.pagination'
    @user.articles.paginate(page: 1, per_page: 20).each do |article|
      assert_match article.title, response.body
    end
  end
end
