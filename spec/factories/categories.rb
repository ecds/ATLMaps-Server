# frozen_string_literal: true

# spec/factories/categories.rb
FactoryBot.define do
  factory :category do
    name { Faker::Beer.style }

    factory :with_tags do
      transient do
        tag_count { 5 }
      end

      after(:create) do |category, evaluator|
        create_list(
          :tag,
          evaluator.tag_count,
          categories: [category]
        )
      end
    end
  end
end
