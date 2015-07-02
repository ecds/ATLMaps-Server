class RasterLayerProjectSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :raster_layer_id, :layer_type, :position
end
