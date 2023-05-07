# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User'

  validates :content, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  after_create :create_project_history

  private

  def create_project_history
    project.project_histories.create!(history_type: :comment, description: content, user: author)
  end
end
