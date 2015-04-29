require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  def setup
    @tag = Fabricate(:tag, name: 'Foo')
  end

  test 'should get show' do
    get :show, id: @tag.id
    assert_response :success
  end
end
