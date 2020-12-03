# frozen_string_literal: true

# spec/factories/vector_features.rb
FactoryBot.define do
  @geo_factory = RGeo::Geographic.simple_mercator_factory
  factory :vector_feature do
    name { Faker::Movies::HitchhikersGuideToTheGalaxy.location }
    tmp_type { 'Point' }
    geometry_collection { RGeo::Geographic.simple_mercator_factory.collection([RGeo::Geographic.simple_mercator_factory.point(Faker::Address.longitude.to_d, Faker::Address.latitude.to_d)]) }
    point { RGeo::Geographic.simple_mercator_factory.point(Faker::Address.longitude.to_d, Faker::Address.latitude.to_d) }
    transient do
      with_media { false }
      with_youtube { false }
      with_youtube_embed { false }
      with_vimeo { false }
      with_images { false }
      with_image { false }
      with_audio { false }
      with_gx_media_links { false }
    end

    properties do
      hash = {
        name: Faker::Movies::HitchhikersGuideToTheGalaxy.planet,
        description: Faker::Hipster.paragraph(sentence_count: 2)
      }

      hash.deep_merge!(
        video: Faker::Internet.url(host: 'youtube.com')
      ) if with_youtube

      hash.deep_merge!(
        video: '<iframe width="560" height="315" src="https://www.youtube.com/embed/8S9iMMxu1U8" frameborder="0" allowfullscreen></iframe>'
      ) if with_youtube_embed

      hash.deep_merge!(
        gx_media_links: Faker::Internet.url(host: 'youtube.com')
      ) if with_gx_media_links

      hash.deep_merge!(
        video: Faker::Internet.url('vimeo.com')
      ) if with_vimeo

      hash
    end
  end
end
