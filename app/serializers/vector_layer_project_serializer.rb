class VectorLayerProjectSerializer < ActiveModel::Serializer

  ActiveModel::Serializer.config.adapter = :json

  attributes :id, :project_id, :vector_layer_id, :marker, :data_format, :position
end
