require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
  end

  test "visitors see the landing page without the tab bar" do
    get root_path
    assert_response :success
    assert_select "nav.liquid-navbar", count: 0
  end

  test "logged-in users land on Train with the tab bar" do
    sign_in @user
    get root_path
    assert_response :success
    assert_select ".liquid-navbar__link.is-active", text: "Train"
  end
end
