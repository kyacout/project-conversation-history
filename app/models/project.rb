# frozen_string_literal: true

class Project < ApplicationRecord
  enum statuses: { ready: 'ready', in_progress: 'in_progress', paused: 'paused', completed: 'complete',
                   canceled: 'canceled' }

  belongs_to :owner, class_name: 'User'
  has_many :comments, dependent: :destroy

  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :title, presence: true
  validates :description, presence: true
end
