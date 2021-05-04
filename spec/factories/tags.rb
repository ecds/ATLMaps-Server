# frozen_string_literal: true

# spec/factories/tags.rb
FactoryBot.define do
  factory :tag do
    name { Faker::Name.unique.first_name }
  end
end
