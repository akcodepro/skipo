module SharedWorkoutsHelper
  AVATAR_COLORS = %w[orange forest mauve yellow].freeze

  def avatar_color(user)
    AVATAR_COLORS[user.id % AVATAR_COLORS.length]
  end
end
