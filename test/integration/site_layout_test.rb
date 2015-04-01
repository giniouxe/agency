require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = Fabricate(:user,
                      name: 'Foobar', email: 'foobar@example.com',
                      password: 'foobar', password_confirmation: 'foobar')
  end

  test 'layout links' do
    get root_path
    assert_template 'pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', contact_path

    get signup_path
    assert_select 'title', full_title('Sign Up')
  end

  test 'layout links when logged in' do
    log_in_as(@user, password: 'foobar')
    get root_path
    assert_template 'pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'a[href=?]', logout_path
  end
end
