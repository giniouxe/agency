require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = Fabricate(:user, name: 'Foobar', email: 'foobar@example.com',
                             password: 'foobar', activated: true,
                             activated_at: Time.zone.now)
  end

  test 'invalid password reset with invalid email' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: 'truc' }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test 'invalid password reset with wrong email link' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: 'wrong@example.com')
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'invalid password reset with inactivated user' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_path
  end

  test 'invalid password reset with invalid token' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_path
  end

  test 'invalid password reset with wrong password and confirmation combination' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'fissbuss', password_confirmation: 'fizzbuzz' }
    assert_select 'div#error-explaination'
    assert_template 'password_resets/edit'
  end

  test 'invalid password reset with blank password' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: '', password_confirmation: '' }
    assert_not flash.empty?
    assert_template 'password_resets/edit'
  end

  test 'invalid password reset with expired reset token' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_not flash.empty?
    assert_redirected_to new_password_reset_path
  end

  test 'valid password reset' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_path
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    patch password_reset_path(user.reset_token),
          email: user.email,
          user: { password: 'fizzbuzz', password_confirmation: 'fizzbuzz' }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
  end
end
