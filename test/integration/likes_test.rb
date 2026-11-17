require "test_helper"

class LikesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = create_user
    sign_in @user

    author = create_user(name: "Leyla")
    @post = create_shared_workout(user: author)
    @deleted_post = create_shared_workout(user: author, deleted: true)
  end

  test "should create a like" do
    assert_difference "Like.count", 1 do
      post shared_workout_like_path(@post)
    end
  end

  test "should not create duplicate likes" do
    post shared_workout_like_path(@post)

    assert_no_difference "Like.count" do
      post shared_workout_like_path(@post)
    end
  end

  test "should destroy a like" do
    post shared_workout_like_path(@post)

    assert_difference "Like.count", -1 do
      delete shared_workout_like_path(@post)
    end
  end

  test "should not like a deleted post" do
    post shared_workout_like_path(@deleted_post)

    assert_response :not_found
  end

  test "unliking a post you never liked does nothing" do
    assert_no_difference "Like.count" do
      delete shared_workout_like_path(@post)
    end
    assert_response :redirect
  end
end
