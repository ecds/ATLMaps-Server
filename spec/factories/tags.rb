# spec/factories/tags.rb
FactoryGirl.define do
    factory :tag do
        name { Faker::Name.unique.first_name }
    end
end
