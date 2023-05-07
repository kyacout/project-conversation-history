# frozen_string_literal: true

FactoryBot.define do
  factory :project_history do
    project
    user

    trait :comment do
      history_type { :comment }
      description { Faker::Lorem.paragraph }
    end

    trait :status_update do
      history_type { :status_update }
      description { "from #{Project.statuses.keys.sample} to #{Project.statuses.keys.sample}" }
    end
  end
end
