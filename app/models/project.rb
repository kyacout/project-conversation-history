# frozen_string_literal: true

class Project < ApplicationRecord
  enum statuses: { ready: 'ready', in_progress: 'in_progress', paused: 'paused', completed: 'complete',
                   canceled: 'canceled' }

  belongs_to :owner, class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :project_histories, dependent: :destroy

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :title, presence: true
  validates :description, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  broadcasts_to ->(_project) { 'projects' }, inserts_by: :prepend

  after_update :create_project_history

  private

  def create_project_history
    return unless saved_change_to_status?

    previous_status, current_status = saved_change_to_status
    project_histories.create!(user: owner, history_type: :status_update,
                              description: "from #{previous_status} to #{current_status}")
  end
end
