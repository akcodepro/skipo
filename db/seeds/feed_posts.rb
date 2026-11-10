CAPTIONS = [
  "Finally got the rhythm right today.",
  "A little session before work. Feeling good.",
  "A good one today. Feeling better already.",
  "Didn't feel like training, glad I did.",
  "Glad I made time for that.",
  "Working on keeping things smooth.",
  "Small wins today.",
  "That was harder than expected!",
  "Getting there, one session at a time.",
  "Much better than last week's attempt.",
  "Just me and the rope this morning.",
  "Consistency over perfection."
].freeze

puts ""
puts "🌱 Seeding feed posts..."

created_count = 0

caption_deck = CAPTIONS.shuffle

FIRST_NAMES.each do |name|
  user = User.find_by!(email: "#{name.downcase}@example.com")
  user.workouts.destroy_all

  # Pick 2 or 3 distinct days within the last 3 weeks
  sessions = rand(2..3)
  days = (1..21).to_a.sample(sessions)

  user_posts = []

  days.each do |day|
    # Generate a realistic session time
    started_at = day.days.ago.change(
      hour: [ 8, 12, 17, 18, 20 ].sample,
      min: 0,
      sec: 0
    )

    # Pick a random workout template
    template = DEMO_TEMPLATES.sample

    # Create workout and session
    session = create_demo_session(
      user: user,
      template: template,
      started_at: started_at,
      status: :completed
    )

    caption = if rand < 0.6 && caption_deck.any?
      caption_deck.shift
    end

    # Share the completed session
    post = SharedWorkout.create!(
      user: user,
      workout_session: session,
      caption: caption,
      created_at: session.completed_at + rand(2..10).minutes
    )

    user_posts << post

    created_count += 1
  end

  photo_path = Rails.root.join("db/seeds/images/posts/#{name.downcase}.jpg")

  if File.file?(photo_path) && user_posts.any?
    post = user_posts.sample

    File.open(photo_path) do |file|
      post.photo.attach(
        io: file,
        filename: "#{name.downcase}.jpg",
        content_type: "image/jpeg"
      )
    end
  end
end

puts "  🆕 #{created_count} feed posts created."
puts "  📊 #{SharedWorkout.count} total shared workouts."
