require "test_helper"

class SharedWorkoutsHelperTest < ActionView::TestCase
  test "returns a consistent avatar colour based on user id" do
    user = User.new(id: 5)

    assert_equal "forest", avatar_color(user)
  end
end
