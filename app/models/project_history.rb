# frozen_string_literal: true

class ProjectHistory < ApplicationRecord
  enum history_types: { comment: 'comment', status_update: 'status_update' }

  belongs_to :project
  belongs_to :user

  validates :history_type, presence: true, inclusion: { in: history_types.keys }
  validates :description, presence: true
end
