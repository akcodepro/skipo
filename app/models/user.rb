class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy
  has_many :workout_sessions, dependent: :destroy
  has_many :shared_workouts, dependent: :destroy
  has_many :likes, dependent: :destroy
end
