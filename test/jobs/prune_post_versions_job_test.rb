require "test_helper"

class PrunePostVersionsJobTest < ActiveJob::TestCase
  test "removes excess versions beyond the limit" do
    post = posts(:draft_post)
    user = users(:admin)

    (PostVersion::MAX_VERSIONS_PER_POST + 3).times do |i|
      post.post_versions.create!(
        user: user,
        version_number: i + 1,
        title: "Version #{i + 1}",
        body_plain: "Content"
      )
    end

    assert_equal PostVersion::MAX_VERSIONS_PER_POST + 3, post.post_versions.count

    PrunePostVersionsJob.perform_now(post.id)

    assert_equal PostVersion::MAX_VERSIONS_PER_POST, post.post_versions.count
    # Newest versions should be kept
    assert_equal PostVersion::MAX_VERSIONS_PER_POST + 3, post.post_versions.ordered.first.version_number
  end

  test "does nothing when under the limit" do
    post = posts(:published_post)
    assert_no_difference "PostVersion.count" do
      PrunePostVersionsJob.perform_now(post.id)
    end
  end

  test "handles missing post gracefully" do
    assert_nothing_raised do
      PrunePostVersionsJob.perform_now(0)
    end
  end
end
