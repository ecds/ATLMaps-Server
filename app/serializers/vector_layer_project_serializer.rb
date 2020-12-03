# frozen_string_literal: true

# Serializer
class VectorLayerProjectSerializer < ActiveModel::Serializer
  belongs_to :vector_layer, serializer: VectorLayerSerializer
  belongs_to :project
  attributes :id, :marker, :data_type, :color_map, :property, :order, :steps, :brewer_scheme, :brewer_group, :manual_steps, :property, :color
end
