# frozen_string_literal: true

class Discussion < ApplicationRecord
  belongs_to :user, default: -> { Current.user }

  validates :name, presence: true

  def to_param
    "#{id}-#{name.first(100)}".parameterize
  end
end
