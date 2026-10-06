require "test_helper"

class WorkoutsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
    sign_in @user
  end

  test "submitting the train form enqueues a generation job and redirects" do
    assert_enqueued_with(job: GenerateWorkoutJob) do
      post workouts_path, params: {
        workout: {
          requested_duration_seconds: 600,
          focus: [ "fundamentals" ],
          difficulty: 3
        }
      }
    end

    assert_redirected_to generating_workouts_path
  end
end
