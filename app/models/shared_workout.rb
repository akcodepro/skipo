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

  validates :workout_session_id, uniqueness: { message: "is already out there." }

  has_one_attached :photo, service: :cloudinary_workout_photos do |attachable|
    attachable.variant :feed, resize_to_fill: [ 1080, 720 ], format: :webp, preprocessed: true
  end

  validate :acceptable_photo
  validate :shareable_session

  scope :visible, -> { where(hidden_at: nil) }

  def liked_by?(user)
    likes.any? { |like| like.user_id == user.id }
  end

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

    def shareable_session
      return unless workout_session

      unless workout_session.completed?
        errors.add(:workout_session, "must be completed")
      end

      unless workout_session.user == user
        errors.add(:workout_session, "must belong to the same user")
      end
    end
end
