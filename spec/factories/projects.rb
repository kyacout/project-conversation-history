# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    status { Project.statuses.keys.sample }
    owner factory: :user
  end
end
