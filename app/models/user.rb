class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  ALLOWED_IMAGE_TYPES = %w[
    image/jpeg
    image/png
    image/webp
    image/heic
    image/heif
    image/avif
  ].freeze

  MAX_PROFILE_PHOTO_SIZE = 10.megabytes

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

  validate :acceptable_profile_photo

  private

  def acceptable_profile_photo
    return unless profile_photo.attached?

    unless ALLOWED_IMAGE_TYPES.include?(profile_photo.blob.content_type)
      errors.add(:profile_photo, "must be a supported image format")
    end

    if profile_photo.blob.byte_size > MAX_PROFILE_PHOTO_SIZE
      errors.add(:profile_photo, "is too large (maximum 10 MB)")
    end
  end
end
