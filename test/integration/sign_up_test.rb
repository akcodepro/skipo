require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest
  test "creates a user when display name is present" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: {
        user: {
          display_name: "Alex",
          email: "alex@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
  end

  test "does not create a user without a display name" do
    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "alex@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
  end
end
