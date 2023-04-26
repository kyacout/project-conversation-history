# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :project
  belongs_to :author, class_name: 'User'

  validates :content, presence: true
end
