require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "user shouldn't be saved if invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "", email: "foo@invalid",
                              password: "foobar", password_confirmation: "foo"}
    end
    assert_template 'users/new'
  end

  test "user should be saved if valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: "Foo Bar",
                                          email: "foobar@example.com",
                                          password: "foobar",
                                          password_confirmation: "foobar"}
    end
    assert_template 'users/show'
  end

  test "should display error messages" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "", email: "foo@invalid",
        password: "foobar", password_confirmation: "foo"}
      end
      assert_template 'users/new'
      assert_select "div", :attributes => {:id => 'error-explaination'}
      assert_select "div", :attributes => {:class => 'field_with_error'}
  end

  test "welcome flash if user saved" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {name: "Foo Bar",
        email: "foobar@example.com",
        password: "foobar",
        password_confirmation: "foobar"}
      end
      assert_template 'users/show'
      assert_not flash.nil?
      assert_select "div", :attributes => {class: "alert alert-succes", content: "Bienvenue chez Solicom"}
    end
end
