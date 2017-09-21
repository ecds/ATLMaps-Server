# spec/factories/raster_layers.rb
FactoryGirl.define do
    factory :project do
        name { Faker::HitchhikersGuideToTheGalaxy.starship }
        description { Faker::HitchhikersGuideToTheGalaxy.quote }
        center_lat { Faker::Address.latitude }
        center_lng { Faker::Address.longitude }
    end
end
