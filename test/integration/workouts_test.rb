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

    @workout = @user.workouts.create!(
      title: "Morning Strength",
      description: "A quick strength workout",
      requested_duration_seconds: 600,
      focus: [ "fundamentals" ],
      difficulty: 2
    )
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

  test "shows the user's own workout" do
    get workout_path(@workout)

    assert_response :success
    assert_select "h1", @workout.title
  end

  test "does not show another user's workout" do
    other_workout = create_other_workout

    get workout_path(other_workout)

    assert_response :not_found
  end

  test "shows the banner for a recent in-progress session" do
    create_workout_session

    get new_workout_path

    assert_response :success
    assert_select ".resume-workout-banner"
  end

  test "hides the banner for an old in-progress session" do
    create_workout_session(started_at: 2.hours.ago)

    get new_workout_path

    assert_response :success
    assert_select ".resume-workout-banner", count: 0
  end

  test "hides another user's in-progress session" do
    other_workout = create_other_workout

    create_workout_session(
      user: other_workout.user,
      workout: other_workout
    )

    get new_workout_path

    assert_response :success
    assert_select ".resume-workout-banner", count: 0
  end

  private
    def create_other_user
      User.create!(
        display_name: "Jamie",
        email: "jamie@example.com",
        password: "password123"
      )
    end

    def create_other_workout
      create_other_user.workouts.create!(
        title: "Jamie's Workout",
        description: "A private workout",
        requested_duration_seconds: 600,
        focus: [ "fundamentals" ],
        difficulty: 2
      )
    end

    def create_workout_session(user: @user, workout: @workout, started_at: Time.current)
      WorkoutSession.create!(
        user: user,
        workout: workout,
        status: :in_progress,
        started_at: started_at
      )
    end
end
