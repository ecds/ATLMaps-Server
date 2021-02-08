# frozen_string_literal: true

# spec/factories/raster_layers.rb
FactoryBot.define do
  factory :project do
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.starship }
    description { Faker::Movies::HitchhikersGuideToTheGalaxy.quote }
    center_lat { 34.000 }
    center_lng { -81.000 }
  end
end
