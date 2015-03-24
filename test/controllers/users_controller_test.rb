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
    get :show, id: @user.id
    assert_response :success
  end

  test 'user profile should show gravatar image' do
    get :show, id: @user.id
    assert_select 'img', attributes: { class: 'gravatar' }
  end

  test 'user profile should have user info sidebar' do
    get :show, id: @user.id
    assert_select 'aside', attributes: { class: 'col-md-4' }
  end
end
