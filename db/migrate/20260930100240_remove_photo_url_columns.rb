class RemovePhotoUrlColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :profile_photo_url, :string, limit: 500
    remove_column :shared_workouts, :photo_url, :string, limit: 500
  end
end
