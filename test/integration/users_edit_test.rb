require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = Fabricate(
    :user,
    name: 'Charlie',
    email: 'charlie@example.com',
    password: 'croquettes')
  end

  test 'unsuccessful edit' do
    log_in_as(@user, password: 'croquettes')
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {
      name: '',
      email: 'invalid',
      password: 'foo',
      password_confirmation: 'bar'
    }
    assert_template 'users/edit'
  end

  test 'successful edit' do
    log_in_as(@user, password: 'croquettes')
    get edit_user_path(@user)
    assert_template 'users/edit'
    new_name = 'Charlie The Cat'
    new_email = 'thecat@example.com'
    patch user_path(@user), user: {
      name: new_name,
      email: new_email,
      password: '',
      password_confirmation: ''
    }
    assert_not flash.empty?, 'Flash should not be empty'
    assert_redirected_to @user, 'Should be redirected to user page'
    @user.reload
    assert_equal @user.name, new_name
    assert_equal @user.email, new_email
  end

  test 'successful edit with helpful forwarding' do
    get edit_user_path(@user)
    log_in_as(@user, password: 'croquettes')
    assert_redirected_to edit_user_path(@user), 'Should redirect to user edit'
    assert session[:forwarding_url].nil?
    new_name = 'Charlie The Cat'
    new_email = 'thecat@example.com'
    patch user_path(@user), user: {
      name: new_name,
      email: new_email,
      password: '',
      password_confirmation: ''
    }
    assert_not flash.empty?, 'Flash should not be empty'
    assert_redirected_to @user, 'Should be redirected to user page'
    @user.reload
    assert_equal @user.name, new_name
    assert_equal @user.email, new_email
  end
end
