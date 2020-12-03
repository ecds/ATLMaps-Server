# frozen_string_literal: true

# spec/factories/vector_layers.rb
FactoryBot.define do
  factory :vector_layer do
    title { Faker::TvShows::RickAndMorty.character }
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.location }
    description { Faker::TvShows::RickAndMorty.quote }
    institution { create(:institution) }
    geometry_type { 'Point' }

    factory :vector_layer_with_features do
      transient do
        features_count { 5 }
      end

      # after(:create) do |vector_layer, evaluator|
      #   create_list(
      #     :vector_feature,
      #     evaluator.features_count,
      #     vector_layer: vector_layer
      #   )
      #   vector_layer.reload
      # end
    end
  end
end
