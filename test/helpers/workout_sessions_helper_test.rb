require "test_helper"

class WorkoutSessionsHelperTest < ActionView::TestCase
  test "shows minutes under an hour" do
    assert_equal "45 min", human_duration(2700)
  end

  test "shows hours and minutes over an hour" do
    assert_equal "9h 18min", human_duration(33480)
  end

  test "shows nearest minute" do
    assert_equal "10 min", human_duration(570)
  end

  test "shows hours without zero minutes" do
    assert_equal "1h", human_duration(3600)
  end

  test "shows 0 minutes when nil" do
    assert_equal "0 min", human_duration(nil)
  end

  test "rounds up to an hour when nearest minute reaches 60" do
    assert_equal "1h", human_duration(3570)
  end

  test "shows Today for a session from today" do
    assert_equal "Today", session_date(Time.current)
  end

  test "shows weekday, day and month for an older session" do
    assert_equal "Tue 27 Oct", session_date(Time.zone.local(2026, 10, 27, 18))
  end
end
