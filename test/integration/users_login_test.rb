require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "wrong email/password combination" do
    get login_path
    assert_template 'sessions/new'
    post login_path, sessions: { email: 'wrong', password: 'wrong' }
    assert_template 'sessions/new'
    assert_not flash.empty?, "flash don't appear"
    get root_path
    assert flash.empty?, "flash not empty"
  end
end
