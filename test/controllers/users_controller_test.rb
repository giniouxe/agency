require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = User.create(
      name: 'Foobar',
      email: 'foobar@example.com',
      password: 'foobar',
      password_confirmation: 'foobar')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'sould get show' do
    get :show, id: @user
    assert_response :success
  end

  test 'user profile should show gravatar image' do
    get :show, id: @user
    assert_select 'img', attributes: { class: 'gravatar' }
  end

  test 'user profile should have user info sidebar' do
    get :show, id: @user
    assert_select 'aside', attributes: { class: 'col-md-4' }
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
end
