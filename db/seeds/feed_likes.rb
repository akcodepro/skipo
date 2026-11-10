puts ""
puts "🌱 Seeding feed likes..."

created_count = 0

# Get the demo users (10 feed users + Jamie)
demo_emails = FIRST_NAMES.map { |name| "#{name.downcase}@example.com" }
demo_emails << "jumper@example.com"

demo_users = User.where(email: demo_emails)

# Only retrieve posts belonging to demo users
demo_posts = SharedWorkout.where(user: demo_users)

demo_posts.find_each do |post|
  # Exclude the post author from potential likers
  potential_likers = demo_users.where.not(id: post.user_id)

  # Pick a random number of likers, including zero
  likers = potential_likers.sample(rand(0..potential_likers.count))

  likers.each do |user|
    Like.create!(
      user: user,
      shared_workout: post
    )

    created_count += 1
  end
end

puts "  👍 #{created_count} likes created."
puts "  📊 #{Like.count} total likes."
