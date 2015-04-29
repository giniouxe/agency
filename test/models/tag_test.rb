require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = Fabricate.build(:tag, name: 'foo')
  end

  test 'should be valid' do
    assert @tag.valid?
  end
end
