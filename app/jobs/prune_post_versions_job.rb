class PrunePostVersionsJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find_by(id: post_id)
    return unless post

    excess_ids = post.post_versions.ordered
      .offset(PostVersion::MAX_VERSIONS_PER_POST)
      .pluck(:id)
    PostVersion.where(id: excess_ids).delete_all if excess_ids.any?
  end
end
