require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = Fabricate(:user, name: 'foobar',
                     email: 'foobar@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'Account_activation' do
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation(@user)
    assert_equal 'Your account activation for Agency', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['accounts@agency.com'], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI::escape(@user.email), mail.body.encoded
  end

  test 'Reset_password' do
    @user.reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal 'Password reset for Agency', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['accounts@agency.com'], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.reset_token, mail.body.encoded
    assert_match CGI::escape(@user.email), mail.body.encoded
  end

end
