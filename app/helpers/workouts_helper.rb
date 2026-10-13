module WorkoutsHelper
  def format_duration(seconds)
    seconds ||= 0

    minutes = seconds / 60
    remaining_seconds = seconds % 60

    return "#{minutes}min" if remaining_seconds.zero?
    format("%dmin %02ds", minutes, remaining_seconds)
  end
end
