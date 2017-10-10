# spec/factories/vector_layers.rb
FactoryGirl.define do
    factory :vector_layer do
        title { Faker::RickAndMorty.character }
        name { Faker::HitchhikersGuideToTheGalaxy.location }
        description { Faker::RickAndMorty.quote }

        factory :vector_layer_with_features do
            transient do
                features_count 5
            end

            after(:create) do |vector_layer, evaluator|
                create_list(
                    :vector_feature,
                    evaluator.features_count,
                    vector_layer: vector_layer
                )
            end
        end
    end
end
