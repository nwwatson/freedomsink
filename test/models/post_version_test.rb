require "test_helper"

class PostVersionTest < ActiveSupport::TestCase
  test "belongs to post and user" do
    version = post_versions(:version_one)
    assert_equal posts(:published_post), version.post
    assert_equal users(:admin), version.user
  end

  test "validates presence of version_number" do
    version = PostVersion.new(post: posts(:published_post), user: users(:admin), title: "Test")
    assert_not version.valid?
    assert_includes version.errors[:version_number], "can't be blank"
  end

  test "validates uniqueness of version_number scoped to post" do
    version = PostVersion.new(
      post: posts(:published_post),
      user: users(:admin),
      version_number: 1,
      title: "Duplicate"
    )
    assert_not version.valid?
    assert_includes version.errors[:version_number], "has already been taken"
  end

  test "validates presence of title" do
    version = PostVersion.new(post: posts(:published_post), user: users(:admin), version_number: 99)
    assert_not version.valid?
    assert_includes version.errors[:title], "can't be blank"
  end

  test "ordered scope returns newest first" do
    versions = PostVersion.where(post: posts(:published_post)).ordered
    assert_equal 2, versions.first.version_number
    assert_equal 1, versions.last.version_number
  end

  test "next_version_number_for returns correct number" do
    assert_equal 3, PostVersion.next_version_number_for(posts(:published_post))
    assert_equal 1, PostVersion.next_version_number_for(posts(:draft_post))
  end

  test "diff_against_current returns a Diffy::Diff" do
    version = post_versions(:version_one)
    diff = version.diff_against_current
    assert_instance_of Diffy::Diff, diff
  end
end
