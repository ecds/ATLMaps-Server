# spec/factories/raster_layers.rb
FactoryGirl.define do
    factory :raster_layer do
        title { Faker::HitchhikersGuideToTheGalaxy.marvin_quote }
        name { Faker::HitchhikersGuideToTheGalaxy.location }
        workspace { Faker::HitchhikersGuideToTheGalaxy.planet }
        institution { create(:institution) }
        active false
    end
end
