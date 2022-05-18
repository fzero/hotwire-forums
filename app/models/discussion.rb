# frozen_string_literal: true

class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :category, counter_cache: true, touch: true

  # Provides discussion.category_name
  delegate :name, prefix: :category, to: :category, allow_nil: true

  has_many :posts, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :posts

  after_create_commit -> { broadcast_prepend_to 'discussions' }
  after_update_commit -> { broadcast_replace_to 'discussions' }
  after_destroy_commit -> { broadcast_remove_to 'discussions' }

  scope :pinned, -> { where(pinned: true) }
  scope :closed, -> { where(closed: true) }

  def to_param
    "#{id}-#{name.first(100)}".parameterize
  end
end
