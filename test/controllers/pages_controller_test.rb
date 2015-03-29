require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test 'should get home' do
    get :home
    assert_response :success
    assert_select 'title', "Agency | Let's communicate!"
  end

  test 'should get contact' do
    get :contact
    assert_response :success
    assert_select 'title', "Contact | Agency | Let's communicate!"
  end
end
