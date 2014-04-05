require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should require all fields" do
    u = User.new
    assert_false u.valid?
  end
end
