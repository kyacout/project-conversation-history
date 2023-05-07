# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    author factory: :user
    project
  end
end
