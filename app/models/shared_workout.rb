class SharedWorkout < ApplicationRecord
  ALLOWED_IMAGE_TYPES = %w[
    image/jpeg
    image/png
    image/webp
    image/heic
    image/heif
    image/avif
    image/gif
  ].freeze

  MAX_PHOTO_SIZE = 10.megabytes

  belongs_to :user
  belongs_to :workout_session

  has_many :likes, dependent: :destroy

  validates :workout_session_id, uniqueness: true

  has_one_attached :photo, service: :cloudinary_workout_photos

  validate :acceptable_photo

  private

  def acceptable_photo
    return unless photo.attached?

    unless ALLOWED_IMAGE_TYPES.include?(photo.blob.content_type)
      errors.add(:photo, "must be a supported image format")
    end

    if photo.blob.byte_size > MAX_PHOTO_SIZE
      errors.add(:photo, "is too large (maximum 10 MB)")
    end
  end
end
