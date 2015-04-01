require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = Fabricate(:user,
      name: 'Foobar',
      email: 'foobar@example.com',
      password: 'foobar',
      password_confirmation: 'foobar')

    @admin = Fabricate(:user,
      name: 'Fizzbuzz',
      email: 'fizzbuzz@example.com',
      password: 'fizzbuzz',
      password_confirmation: 'fizzbuzz',
      admin: true)

    Fabricate.times(30, :user) do
      name { Faker::Name.name }
      email { |attrs| "#{attrs[:name].parameterize}@example.com" }
      password { 'password' }
      password_confirmation { 'password' }
    end
  end

  test 'index as non admin with pagination' do
    log_in_as(@user, password: 'foobar')
    get users_path
    assert :success
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1, per_page: 20).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
    assert_select 'a', text: 'Delete user', count: 0
  end

  test 'index when logged as dmin with pagination and delete links' do
    log_in_as(@admin, password: 'fizzbuzz')
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    users_first_page = User.paginate(page: 1, per_page: 20)
    users_first_page.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'Delete user',
                                                    method: :delete
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end
end
