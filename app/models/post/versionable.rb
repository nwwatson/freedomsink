module Post::Versionable
  extend ActiveSupport::Concern

  VERSION_COOLDOWN = 5.minutes

  included do
    has_many :post_versions, dependent: :destroy
  end

  def create_version!(user:)
    version = post_versions.create!(
      user: user,
      version_number: PostVersion.next_version_number_for(self),
      title: title,
      subtitle: subtitle,
      content_html: content&.body&.to_html,
      body_plain: body_plain
    )
    prune_old_versions!
    version
  end

  def create_version_if_needed!(user:)
    return unless version_cooldown_elapsed?

    create_version!(user: user)
  end

  def version_cooldown_elapsed?
    last_version = post_versions.ordered.first
    last_version.nil? || last_version.created_at < VERSION_COOLDOWN.ago
  end

  def restore_version!(version)
    update!(
      title: version.title,
      subtitle: version.subtitle,
      content: version.content_html
    )
  end

  private

  def prune_old_versions!
    excess_ids = post_versions.ordered
      .offset(PostVersion::MAX_VERSIONS_PER_POST)
      .pluck(:id)
    post_versions.where(id: excess_ids).delete_all if excess_ids.any?
  end
end
