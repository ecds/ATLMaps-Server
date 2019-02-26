# spec/factories/institutions.rb
FactoryGirl.define do
    factory :institution do
        geoserver { Faker::HitchhikersGuideToTheGalaxy.specie }
        name { Faker::HitchhikersGuideToTheGalaxy.specie }
    end
end
