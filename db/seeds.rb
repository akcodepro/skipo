# Seed files must run in this order

# Seed exercises and shared workout definitions
load Rails.root.join("db/seeds/exercises.rb")
load Rails.root.join("db/seeds/templates.rb")

# Generate demo account and workout history
load Rails.root.join("db/seeds/demo.rb")

# Generate social feed data
load Rails.root.join("db/seeds/feed_users.rb")
#load Rails.root.join("db/seeds/feed_posts.rb")
#load Rails.root.join("db/seeds/feed_likes.rb")
