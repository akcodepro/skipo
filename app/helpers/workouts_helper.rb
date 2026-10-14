module WorkoutsHelper
  FOCUS_ICONS = {
    "fundamentals" => "fa-solid fa-bullseye",
    "footwork" => "fa-solid fa-shoe-prints",
    "rhythm_coordination" => "fa-solid fa-music",
    "power" => "fa-solid fa-bolt",
    "technical" => "fa-solid fa-gears",
    "freestyle" => "fa-solid fa-wand-magic-sparkles"
  }.freeze
  private_constant :FOCUS_ICONS

  def format_duration(seconds)
    seconds ||= 0

    minutes = seconds / 60
    remaining_seconds = seconds % 60

    return "#{minutes}min" if remaining_seconds.zero?
    format("%dmin %02ds", minutes, remaining_seconds)
  end

  def focus_icon(category, extra_class: nil)
    icon_class = FOCUS_ICONS[category.to_s]
    return unless icon_class

    tag.i(
      class: class_names(icon_class, extra_class),
      aria: { hidden: true }
    )
  end
end
