# frozen_string_literal: true

# spec/factories/raster_layers.rb
FactoryBot.define do
  factory :raster_layer do
    title { Faker::Movies::HitchhikersGuideToTheGalaxy.marvin_quote }
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.location }
    workspace { Faker::Movies::HitchhikersGuideToTheGalaxy.planet.gsub(' ', '') }
    institution { create(:institution) }
    active { false }
    maxx { -84.37832072 }
    maxy { 33.66527065 }
    minx { -84.46091263 }
    miny { 33.61212486 }

    factory :raster_with_tags do
      active { true }
      transient do
        tags_count { create_list(tags, 5) }
      end

      # before(:create) do |raster_layer, evaluator|
      #     create_list(:tag, evaluator.tags_count)
      # end
      before(:create) do |raster_layer, _evaluator|
        raster_layer.tag_list.add(Tag.last.name)
      end
    end
  end
end
