# spec/factories/raster_layers.rb
FactoryBot.define do
    factory :project do
        name { Faker::Movies::HitchhikersGuideToTheGalaxy.starship }
        description { Faker::Movies::HitchhikersGuideToTheGalaxy.quote }
        center_lat { Faker::Address.latitude }
        center_lng { Faker::Address.longitude }
    end
end
