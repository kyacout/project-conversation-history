# frozen_string_literal: true

class Project < ApplicationRecord
  enum statuses: { ready: 'ready', in_progress: 'in_progress', paused: 'paused', completed: 'complete', canceled: 'canceled' }

  belongs_to :owner, class_name: 'User'

  validates :status, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :status, inclusion: { in: statuses.keys }
end
