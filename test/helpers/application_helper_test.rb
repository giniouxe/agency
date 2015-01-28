require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full_title helper" do
    assert_equal full_title(''),        "Sample App"
    assert_equal full_title("Sign Up"), "Sign Up | Sample App"
  end
end
