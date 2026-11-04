class WorkoutSessionsController < ApplicationController
  RANGES = %w[3m 1y all].freeze

  def index
    @range = RANGES.include?(params[:range]) ? params[:range] : "3m"

    range_start = range_start_for(@range)

    finished_sessions = current_user
      .workout_sessions
      .finished
      .where(started_at: range_start..)

    @workout_sessions = finished_sessions
      .includes(workout: { workout_exercises: :exercise })
      .order(started_at: :desc)

    @usual_duration_seconds = finished_sessions.usual_duration_seconds
    @usual_difficulty = finished_sessions.usual_difficulty
    @focus_mix = finished_sessions.focus_mix

    this_week = finished_sessions.where(started_at: Time.current.beginning_of_week..)

    @week_seconds = this_week.sum(:actual_duration_seconds)
    @week_count = this_week.count

    @range_seconds = finished_sessions.sum(:actual_duration_seconds)
    @range_count = finished_sessions.count
  end

  def create
    workout = current_user.workouts.find(params[:workout_id])
    workout_session = workout.workout_sessions.create!(
      user: current_user,
      status: :in_progress,
      started_at: Time.current
    )
    redirect_to workout_session_path(workout_session)
  end

  def show
    @workout_session = current_user.workout_sessions.find(params[:id])
  end

  def update
    workout_session = current_user.workout_sessions.find(params[:id])
    unless workout_session.in_progress?
      redirect_to workout_session_path(workout_session), alert: "This session is no longer in progress."
      return
    end

    session_params = workout_session_params
    unless %w[completed stopped].include?(session_params[:status])
      redirect_to workout_session_path(workout_session), alert: "Invalid session status."
      return
    end

    duration = session_params[:actual_duration_seconds].to_i.clamp(
      0,
      workout_session.workout.total_duration_seconds
    )

    workout_session.update!(
      status: session_params[:status],
      completed_at: Time.current,
      actual_duration_seconds: duration
    )

    redirect_to workout_session_path(workout_session)
  end

  private
    def workout_session_params
      params.expect(workout_session: [ :status, :actual_duration_seconds ])
    end

    def range_start_for(range)
      case range
      when "3m"
        3.months.ago.beginning_of_week
      when "1y"
        11.months.ago.beginning_of_month
      when "all"
        nil
      end
    end
end
