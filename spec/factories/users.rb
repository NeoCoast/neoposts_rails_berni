# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    nickname { Faker::Name.name.gsub(/[^0-9A-Za-z]/, '') }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
    birthday { Faker::Date.backward(days: 14) }
  end
end
