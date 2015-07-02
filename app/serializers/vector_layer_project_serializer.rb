class VectorLayerProjectSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :vector_layer_id, :marker, :layer_type, :position
end
