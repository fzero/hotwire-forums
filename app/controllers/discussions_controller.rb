# frozen_string_literal: true

class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: %i[edit show update destroy]

  def index
    @pagy, @discussions = pagy(Discussion.includes(:category).pinned_first)
  end

  def new
    @discussion = Discussion.new
    @discussion.posts.new
  end

  def show
    @pagy, @posts = pagy(@discussion.posts.includes(:user, :rich_text_body).order(created_at: :asc))
    @new_post = @discussion.posts.new
  end

  def create
    @discussion = Discussion.new(discussion_params)

    respond_to do |format|
      if @discussion.save
        format.html { redirect_to @discussion, notice: 'Discussion created' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        DiscussionBroadcaster.new(@discussion).broadcast!
        format.html { redirect_to @discussion, notice: 'Discussion updated' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discussion.destroy!
    redirect_to discussion_path, notice: 'Discussion removed'
  end

  private

  def discussion_params
    params
      .require(:discussion)
      .permit(:name, :category_id, :closed, :pinned, posts_attributes: :body)
  end

  def set_discussion
    @discussion = Discussion.find(params[:id])
  end
end
