class RasterLayerProjectSerializer < ActiveModel::Serializer

  ActiveModel::Serializer.config.adapter = :json
  
  attributes :id, :project_id, :raster_layer_id, :layer_type, :position
end
