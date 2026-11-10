puts ""
puts "🌱 Seeding feed users..."

first_names = [
  "Blake",
  "Breanna",
  "Charlotte",
  "Flynn",
  "Jayden",
  "Kirra",
  "Lachlan",
  "Leyla",
  "Riley",
  "Tahlia"
]

created_count = 0
existing_count = 0
avatars_attached_count = 0
avatars_skipped_count = 0
missing_avatars = []

first_names.each do |name|
  email = "#{name.downcase}@example.com"
  user_created = false

  user = User.find_or_create_by!(email: email) do |new_user|
    user_created = true
    new_user.password = SecureRandom.hex(16)
    new_user.display_name = name
  end

  if user_created
    created_count += 1
  else
    existing_count += 1
  end

  if user.profile_photo.attached?
    avatars_skipped_count += 1
  else
    path = Rails.root.join("db/seeds/images/avatars", "#{name.downcase}.jpg")

    if File.file?(path)
      File.open(path) do |file|
        user.profile_photo.attach(
          io: file,
          filename: "#{name.downcase}.jpg"
        )
      end

      avatars_attached_count += 1
    else
      missing_avatars << path.basename.to_s
    end
  end
end

puts "  👥 #{created_count} new users created."
puts "  ♻️ #{existing_count} existing users reused."
puts "  📸 #{avatars_attached_count} avatars attached."
puts "  ⏭️ #{avatars_skipped_count} existing avatars skipped."
puts "  📊 #{User.count} total users in the database."


unless missing_avatars.empty?
  warn "⚠️ Missing avatar files: #{missing_avatars.join(', ')}"
end
