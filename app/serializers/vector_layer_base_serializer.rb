# frozen_string_literal: true

# app/serializers/vector_layer_serializer.rb
class VectorLayerBaseSerializer < LayerSerializer
  # has_many :vector_feature, serializer: VectorFeatureSerializer
  # has_many :vector_features, serializer: VectorFeatureSerializer
  attributes :tmp_color, :tmp_type, :geometry_type, :data_type, :data_format
end