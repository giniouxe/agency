require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full_title helper' do
    assert_equal full_title(''),        "Agency | Let's communicate!"
    assert_equal full_title('Sign Up'), "Sign Up | Agency | Let's communicate!"
  end
end
