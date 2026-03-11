class PostVersion < ApplicationRecord
  MAX_VERSIONS_PER_POST = 50

  belongs_to :post
  belongs_to :user

  validates :version_number, presence: true, uniqueness: { scope: :post_id }
  validates :title, presence: true

  scope :ordered, -> { order(version_number: :desc) }

  def self.next_version_number_for(post)
    where(post: post).maximum(:version_number).to_i + 1
  end

  def diff_against_current
    Diffy::Diff.new(body_plain.to_s, post.body_plain.to_s, context: 3)
  end
end
