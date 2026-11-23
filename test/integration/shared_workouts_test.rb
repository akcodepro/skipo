require "test_helper"

class SharedWorkoutsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
    sign_in @user

    # Two workouts with different titles, so we can tell them apart on the page
    workout_a = @user.workouts.create!(
      title: "Morning fundamentals",
      requested_duration_seconds: 900,
      focus: [ "fundamentals" ],
      difficulty: 2
    )
    workout_b = @user.workouts.create!(
      title: "Afternoon strength",
      requested_duration_seconds: 300,
      focus: [ "fundamentals", "power" ],
      difficulty: 3
    )

    # A post needs a session, so each workout gets one
    session_a = WorkoutSession.create!(
      user: @user,
      workout: workout_a,
      status: "completed",
      actual_duration_seconds: 900
    )
    session_b = WorkoutSession.create!(
      user: @user,
      workout: workout_b,
      status: "completed",
      actual_duration_seconds: 300
    )

    # One visible post, one soft-deleted post
    SharedWorkout.create!(user: @user, workout_session: session_a)
    SharedWorkout.create!(user: @user, workout_session: session_b, deleted_at: Time.current)
  end

  test "feed shows visible posts and hides deleted ones" do
    get shared_workouts_path

    assert_response :success
    assert_select ".feed-post__title", text: "Morning fundamentals"
    assert_select ".feed-post__title", text: "Afternoon strength", count: 0
  end

  test "shows empty state when there are no shared workouts" do
    SharedWorkout.destroy_all

    get shared_workouts_path

    assert_response :success
    assert_select "h1", "Feed"
    assert_select ".coming-soon__title", "Your feed starts here"
  end

  test "shares my completed workout" do
    workout_session = create_finished_session(user: @user)

    assert_difference "SharedWorkout.count", 1 do
      share(workout_session, caption: "Legs are done.")
    end

    assert_redirected_to shared_workouts_path
    shared_workout = SharedWorkout.last
    assert_equal "Legs are done.", shared_workout.caption
    assert_equal @user, shared_workout.user
  end

  test "cannot share my stopped workout" do
    workout_session = create_finished_session(user: @user, status: "stopped")

    assert_no_difference "SharedWorkout.count" do
      share(workout_session)
    end

    assert_response :not_found
  end

  test "cannot share someone else's completed workout" do
    workout_session = create_finished_session(user: create_user(name: "Sam"))

    assert_no_difference "SharedWorkout.count" do
      share(workout_session)
    end

    assert_response :not_found
  end

  test "cannot share the same workout twice" do
    workout_session = create_finished_session(user: @user)
    share(workout_session, caption: "First share.")

    assert_no_difference "SharedWorkout.count" do
      share(workout_session, caption: "Second share.")
    end

    assert_redirected_to workout_session_path(workout_session)
    assert_equal "Workout session is already out there.", flash[:alert]
    assert_equal "First share.", SharedWorkout.last.caption
  end

  private
    def share(workout_session, caption: "Legs are done.")
      post workout_session_shared_workout_path(workout_session),
        params: { shared_workout: { caption: caption } }
    end
end
