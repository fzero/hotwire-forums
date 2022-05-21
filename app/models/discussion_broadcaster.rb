# frozen_string_literal: true

class DiscussionBroadcaster
  attr_reader(:discussion)

  def initialize(discussion)
    @discussion = discussion
  end

  def broadcast!
    replace_header
    replace_new_post_form if discussion.saved_change_to_closed?
    move_categories if discussion.saved_change_to_category_id?
  end

  private

  def replace_header
    discussion.broadcast_replace(
      partial: 'discussions/header',
      locals: { discussion: }
    )
  end

  def replace_new_post_form
    discussion.broadcast_action_to(
      discussion,
      action: :replace,
      target: 'new_post_form', # This is the dom id of the turbo-frame
      partial: 'discussions/posts/form',
      locals: { post: discussion.posts.new }
    )
  end

  def move_categories
    old_category_id, new_category_id = discussion.saved_change_to_category_id

    old_category = Category.find(old_category_id)
    new_category = Category.find(new_category_id)

    # Update discussions in category lists
    discussion.broadcast_remove_to(old_category)
    discussion.broadcast_prepend_to(new_category)

    # Update category list and discussion counts
    old_category.reload.broadcast_replace_to('categories')
    new_category.reload.broadcast_replace_to('categories')
  end
end
