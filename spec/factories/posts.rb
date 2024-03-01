# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph }
    published_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
