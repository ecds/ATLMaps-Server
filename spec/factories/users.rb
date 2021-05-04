# frozen_string_literal: true

# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    displayname { Faker::Movies::Lebowski.character }
    email { Faker::Internet.email }
  end
end
