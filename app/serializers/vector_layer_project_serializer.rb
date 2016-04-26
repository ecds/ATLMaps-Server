class VectorLayerProjectSerializer < ActiveModel::Serializer

  attributes :id, :project_id, :vector_layer_id, :marker, :data_format, :position
end
