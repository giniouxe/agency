require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = Fabricate(:user, name: 'foobar',
                     email: 'foobar@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'Your account activation for Agency', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "reset_password" do
    mail = UserMailer.reset_password
    assert_equal "Reset password", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
