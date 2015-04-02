require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'user should not be saved if invalid signup informations' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {
        name: '',
        email: 'foo@invalid',
        password: 'foobar',
        password_confirmation: 'foo' }
    end
    assert_template 'users/new'
    assert_select 'div', attributes: { id: 'error-explaination' }
    assert_select 'div', attributes: { class: 'field_with_error' }
  end

  test 'Sign up with valid informations and activate account' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { name: 'Foo Bar',
                               email: 'foobar@example.com',
                               password: 'foobar',
                               password_confirmation: 'foobar' }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user, password: 'foobar')
    assert_not is_logged_in?
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?, 'User should be logged in'
    assert_not flash.nil?
    assert_select 'div', attributes: {
      class: 'alert alert-succes',
      content: 'Welcome to Agency' }
  end
end
