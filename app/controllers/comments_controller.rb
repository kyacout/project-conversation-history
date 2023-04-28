# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]
  before_action :authenticate_user!

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.project_id = params[:project_id]

    ActiveRecord::Base.transaction do
      @comment.project.project_histories.create!(user: current_user, history_type: :comment,
                                         description: comment_params[:content])
      @comment.save!
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    @comment.update(comment_params)
  end

  # DELETE /comments/1 or /comments/1.json
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
