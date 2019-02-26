# spec/factories/raster_layers.rb
FactoryGirl.define do
    factory :raster_layer do
        title { Faker::HitchhikersGuideToTheGalaxy.marvin_quote }
        name { Faker::HitchhikersGuideToTheGalaxy.location }
        workspace { Faker::HitchhikersGuideToTheGalaxy.planet }
        institution { create(:institution) }
        active false

        factory :raster_with_tags do
            active true
            transient do
                tags_count 5
            end

            # before(:create) do |raster_layer, evaluator|
            #     create_list(:tag, evaluator.tags_count)
            # end
            before(:create) do |raster_layer, evaluator|
                raster_layer.tag_list.add(Tag.last.name)
                puts raster_layer.tag_list
            end
        end
    end
end
