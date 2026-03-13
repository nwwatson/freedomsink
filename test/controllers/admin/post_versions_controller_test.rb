require "test_helper"

class Admin::PostVersionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(:admin)
    @post = posts(:published_post)
    @version = post_versions(:version_one)
  end

  test "GET index lists versions" do
    get admin_post_post_versions_path(@post)
    assert_response :success
  end

  test "GET show renders diff view" do
    get admin_post_post_version_path(@post, @version)
    assert_response :success
  end

  test "POST create saves a manual version" do
    assert_difference "PostVersion.count", 1 do
      post admin_post_post_versions_path(@post)
    end
    assert_redirected_to admin_post_post_versions_path(@post)
  end

  test "POST restore restores a version" do
    post restore_admin_post_post_version_path(@post, @version)
    assert_redirected_to edit_admin_post_path(@post)

    @post.reload
    assert_equal "Original Title", @post.title
  end

  test "requires authentication" do
    delete admin_session_path
    get admin_post_post_versions_path(@post)
    assert_response :redirect
  end
end
