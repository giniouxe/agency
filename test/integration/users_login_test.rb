require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
      @user = Fabricate(:user,
                        name: 'Charlie',
                        email: 'charlie@example.com',
                        password: 'croquettes')
  end

  test "login with invalid informations" do
    get login_path
    assert_template 'sessions/new'
    post login_path, sessions: { email: @user.email, password: 'nocroquettes' }
    assert_template 'sessions/new'
    assert_not flash.empty?, "flash don't appear"
    get root_path
    assert flash.empty?, "flash not empty"
  end

  test "login with valid informations then logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, sessions: { email: @user.email, password: 'croquettes' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'pages/home'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
