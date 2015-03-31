require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = Fabricate(:user,
      name: 'Foobar',
      email: 'foobar@example.com',
      password: 'foobar',
      password_confirmation: 'foobar')

    Fabricate.times(30, :user) do
      name { Faker::Name.name }
      email { |attrs| "#{attrs[:name].parameterize}@example.com" }
      password { 'password' }
      password_confirmation { 'password' }
    end
  end

  test 'index with pagination' do
    log_in_as(@user, password: 'foobar')
    get users_path
    assert :success
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 2).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
