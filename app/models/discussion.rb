# frozen_string_literal: true

class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  has_many :posts, dependent: :destroy

  validates :name, presence: true

  after_create_commit -> { broadcast_prepend_to "discussions" }
  after_update_commit -> { broadcast_replace_to "discussions" }
  after_destroy_commit -> { broadcast_remove_to "discussions" }

  default_scope { order(created_at: :desc) }
  scope :pinned, -> { where(pinned: true) }
  scope :closed, -> { where(closed: true) }

  def to_param
    "#{id}-#{name.first(100)}".parameterize
  end
end
