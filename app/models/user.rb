class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy
  has_many :workout_sessions, dependent: :destroy
  has_many :shared_workouts, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :display_name, presence: true, length: { maximum: 100 }

  validates :username,
            uniqueness: true,
            length: { maximum: 50 },
            allow_nil: true

  has_one_attached :profile_photo, service: :cloudinary_profile_photos
end
