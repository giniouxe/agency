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
end
