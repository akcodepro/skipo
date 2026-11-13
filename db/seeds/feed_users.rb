
puts ""
puts "🌱 Seeding feed users..."

created_count = 0
existing_count = 0
avatars_attached_count = 0
avatars_skipped_count = 0
avatars_purged_count = 0
users_without_avatar = []

FIRST_NAMES.each do |name|
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

  path = Rails.root.join("db/seeds/images/avatars", "#{name.downcase}.jpg")

  if File.file?(path)
    if user.profile_photo.attached?
      avatars_skipped_count += 1
    else
      File.open(path) do |file|
        user.profile_photo.attach(
          io: file,
          filename: "#{name.downcase}.jpg"
        )
      end

      avatars_attached_count += 1
    end
  else
    if user.profile_photo.attached?
      user.profile_photo.purge
      avatars_purged_count += 1
    else
      users_without_avatar << name
    end
  end
end

puts "  👥 #{created_count} new users created."
puts "  ♻️ #{existing_count} existing users reused."
puts "  📸 #{avatars_attached_count} avatars attached."
puts "  ⏭️ #{avatars_skipped_count} existing avatars skipped."
puts "  🗑️ #{avatars_purged_count} avatars purged."
puts "  📊 #{User.count} total users in the database."

unless users_without_avatar.empty?
  puts "  👤 Users without an avatar: #{users_without_avatar.join(', ')}"
end
