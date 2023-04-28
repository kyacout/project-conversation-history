# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]
  before_action :authenticate_user!

  # POST /projects/:id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.project_id = params[:project_id]

    ActiveRecord::Base.transaction do
      @comment.project.project_histories.create!(user: current_user, history_type: :comment,
                                                 description: comment_params[:content])
      @comment.save!
    end

    redirect_to project_url(@comment.project), notice: 'Comment was successfully created.'
  end

  # PATCH/PUT /projects/:id/comments
  def update
    @comment.update(comment_params)
  end

  # DELETE /projects/:id/comments
  def destroy
    @comment.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:content, :project_id)
  end
end
