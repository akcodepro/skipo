class Like < ApplicationRecord
  belongs_to :user
  belongs_to :shared_workout
end
