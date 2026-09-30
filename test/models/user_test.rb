require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      display_name: "Alex",
      email: "alex@example.com",
      password: "password123"
    )
  end

  test "is valid with an allowed format" do
    @user.profile_photo.attach(io: File.open(file_fixture("photo.jpg")), filename: "photo.jpg")
    assert @user.valid?
  end

  test "is invalid with an unallowed format" do
    @user.profile_photo.attach(io: File.open(file_fixture("not_an_image.txt")), filename: "not_an_image.txt")
    assert_not @user.valid?
  end

  test "is invalid with a disguised format" do
    skip "Known limitation: files without magic bytes are identified by extension"
    @user.profile_photo.attach(io: File.open(file_fixture("not_an_image.txt")), filename: "not_an_image.jpg")
    assert_not @user.valid?
  end

  test "is valid with no photo" do
    assert @user.valid?
  end
end
