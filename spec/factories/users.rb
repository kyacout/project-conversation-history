# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.safe_email }
    password { 'password123' }
    password_confirmation { password }
  end
end
