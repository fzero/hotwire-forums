# frozen_string_literal: true

class AddPostCountToDiscussions < ActiveRecord::Migration[6.1]
  def change
    add_column :discussions, :posts_count, :integer, default: 0
  end
end
