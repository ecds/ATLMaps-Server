# frozen_string_literal: true

# spec/factories/institutions.rb
FactoryBot.define do
  factory :institution do
    geoserver { Faker::Movies::HitchhikersGuideToTheGalaxy.specie }
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.specie }
  end
end
