# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    association :followed, factory: :user
    association :follower, factory: :user
  end
end
