# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :discussions, dependent: :nullify

  scope :sorted, -> { order(name: :asc) }

  after_create_commit -> { broadcast_prepend_to 'categories' }
  after_update_commit -> { broadcast_replace_to 'categories' }
  after_destroy_commit -> { broadcast_remove_to 'categories' }

  def to_param
    "#{id}-#{name.first(100)}".parameterize
  end
end
