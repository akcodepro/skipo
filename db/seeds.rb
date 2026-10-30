# Order Matter for success

# Create or Update Exercises
load Rails.root.join("db/seeds/exercises.rb")

# Erase Demo-User account with everything related
# then Create Demo-User account + Workout-Sessions
load Rails.root.join("db/seeds/demo.rb")
