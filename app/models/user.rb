# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :projects, foreign_key: :owner_id, dependent: :destroy
  has_many :comments, foreign_key: :author_id, dependent: :destroy
end
