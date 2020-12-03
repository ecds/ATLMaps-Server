# frozen_string_literal: true

# app/serializers/vector_layer_serializer.rb
class VectorLayerSerializer < VectorLayerBaseSerializer
  # has_many :vector_feature, serializer: VectorFeatureSerializer
  # has_many :vector_features, serializer: VectorFeatureSerializer
  attributes :id, :properties, :workspace, :property_id, :geo_url, :geojson, :default_break_property, :color_map
end
