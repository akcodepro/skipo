module WorkoutsHelper
  def format_duration(seconds)
    minutes = seconds / 60
    remaining_seconds = seconds % 60

    if remaining_seconds.zero?
      "#{minutes} min"
    else
      "#{minutes} min #{remaining_seconds} sec"
    end
  end
end
