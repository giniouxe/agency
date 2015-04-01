require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = Fabricate(:user,
                      name: 'Foobar',
                      email: 'foobar@example.com',
                      password: 'foobar',
                      password_confirmation: 'foobar')

    @other_user = Fabricate(:user,
                            name: 'Fizzbuzz',
                            email: 'fizzbuzz@example.com',
                            password: 'fizzbuzz',
                            password_confirmation: 'fizzbuzz')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'edit should redirect to login page when user not logged in' do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'update should redirect to login page when user not logged in' do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'edit should redirect to login page when wrong user' do
    log_in_as(@other_user, password: 'fizzbuzz')
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'update should redirect to login page when wrong user' do
    log_in_as(@other_user, password: 'fizzbuzz')
    patch :edit, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'index should redirect to login page when not logged in' do
    get :index
    assert_redirected_to login_path
  end

  test 'show user should redirect to login page when not logged in' do
    get :show, id: @user
    assert_redirected_to login_path
  end

  test 'show other user should redirect to login page when not logged in' do
    get :show, id: @other_user
    assert_redirected_to login_path
  end

  test 'user profile should show gravatar image' do
    log_in_as(@user, password: 'foobar')
    get :show, id: @user
    assert_select 'img', attributes: { class: 'gravatar' }
  end

  test 'user profile should have user info sidebar' do
    log_in_as(@user, password: 'foobar')
    get :show, id: @user
    assert_select 'aside', attributes: { class: 'col-md-4' }
  end

  test 'admin attribute cannot be updated via the web' do
    log_in_as(@other_user, password: 'fizzbuzz')
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: {
      password: @other_user.password,
      password_confirmation: @other_user.password,
      admin: true }
    assert_not @other_user.reload.admin?
  end

  test 'destroy should redirect to login when user not logged in' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_path
  end

  test 'destroy should redirect to home when not logged as admin' do
    log_in_as(@other_user, password: 'fizzbuzz')
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_path
  end
end
