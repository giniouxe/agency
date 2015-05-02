require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  def setup
    @user = Fabricate(:user, name: 'Foobar', email: 'foobar@example.com',
                             password: 'foobar', activated: true,
                             activated_at: Time.zone.now)
    @tag = Fabricate(:tag, name: 'Foo')
  end

  test 'should get show' do
    log_in_as(@user, password: 'foobar')
    get :show, id: @tag
    assert_response :success
  end

  test 'should redirect edit when user not logged in' do
    post :update, id: @tag, tag: { name: 'Foobar' }
    assert_redirected_to login_path
  end

  test 'should redirect destroy when user not logged in' do
    assert_no_difference 'Tag.count' do
      delete :destroy, id: @tag
    end
    assert_redirected_to login_path
  end

  test 'should redirect edit to home when user not admin' do
    log_in_as(@user, password: 'foobar')
    get :edit, id: @tag
    assert_redirected_to root_path
  end

  test 'should redirect update to home when user not admin' do
    log_in_as(@user, password: 'foobar')
    post :update, id: @tag, tag: { name: 'Foobar' }
    assert_equal 'Foo', @tag.name
    assert_redirected_to root_path
  end

  test 'should redirect destroy to home when user not admin' do
    log_in_as(@user, password: 'foobar')
    assert_no_difference 'Tag.count' do
      delete :destroy, id: @tag
    end
    assert_redirected_to root_path
  end
end
