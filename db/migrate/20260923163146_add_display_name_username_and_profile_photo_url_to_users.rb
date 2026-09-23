class AddDisplayNameUsernameAndProfilePhotoUrlToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :display_name, :string, null: false, limit: 100
    add_column :users, :username, :string, limit: 50
    add_column :users, :profile_photo_url, :string, limit: 500

    add_index :users, :username, unique: true
  end
end
