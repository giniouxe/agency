require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full_title helper' do
    assert_equal full_title(''),        'Solicom | Agence de communication'
    assert_equal full_title('Sign Up'), 'Sign Up | Solicom | Agence de communication'
  end
end
