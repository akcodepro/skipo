ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def create_user(name: "Alex")
      User.create!(
        display_name: name,
        email: "#{name.downcase}-#{SecureRandom.hex(4)}@example.com",
        password: "password123"
      )
    end

    def create_finished_session(user:, title: "Test workout", status: "completed")
      workout = user.workouts.create!(
        title:,
        focus: [ "footwork" ],
        difficulty: 2,
        requested_duration_seconds: 600
      )
      WorkoutSession.create!(user:, workout:, status:, actual_duration_seconds: 600)
    end

    def create_shared_workout(user:, title: "Test workout", deleted: false)
      SharedWorkout.create!(
        user:,
        workout_session: create_finished_session(user:, title:),
        deleted_at: (Time.current if deleted)
      )
    end
  end
end
