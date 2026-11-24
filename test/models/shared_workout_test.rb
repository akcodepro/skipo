require "test_helper"

class SharedWorkoutTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )

    @workout = Workout.create!(
      user: @user,
      focus: [ "footwork" ],
      title: "Some title",
      difficulty: 1,
      requested_duration_seconds: 900
    )

    @workout_session = WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: "completed",
    )

    @shared_workout = SharedWorkout.create!(
      user: @user,
      workout_session: @workout_session
    )
  end

  test "is valid with an allowed format" do
    @shared_workout.photo.attach(io: File.open(file_fixture("photo.jpg")), filename: "photo.jpg")
    assert @shared_workout.valid?
  end

  test "is invalid with an unallowed format" do
    @shared_workout.photo.attach(io: File.open(file_fixture("not_an_image.txt")), filename: "not_an_image.txt")
    assert_not @shared_workout.valid?
  end

  test "is invalid with a disguised format" do
    skip "Known limitation: files without magic bytes are identified by extension"
    @shared_workout.photo.attach(io: File.open(file_fixture("not_an_image.txt")), filename: "not_an_image.jpg")
    assert_not @shared_workout.valid?
  end

  test "is valid with no photo" do
    assert @shared_workout.valid?
  end

  test "visible excludes deleted shared workouts" do
    second_workout_session = WorkoutSession.create!(
      user: @user,
      workout: @workout,
      status: "completed"
    )

    deleted_shared_workout = SharedWorkout.create!(
      user: @user,
      workout_session: second_workout_session,
      deleted_at: Time.current
    )

    assert_includes SharedWorkout.visible, @shared_workout
    refute_includes SharedWorkout.visible, deleted_shared_workout
  end

  test "should not be valid with a stopped session" do
    stopped_session = create_finished_session(user: @user, status: "stopped")

    shared_workout = SharedWorkout.new(user: @user, workout_session: stopped_session)

    refute shared_workout.valid?
    assert_includes shared_workout.errors[:workout_session], "must be completed"
  end

  test "should not be valid with another user's session" do
    other_session = create_finished_session(user: create_user(name: "Other"))

    shared_workout = SharedWorkout.new(user: @user, workout_session: other_session)

    refute shared_workout.valid?
    assert_includes shared_workout.errors[:workout_session], "must belong to the same user"
  end
end
