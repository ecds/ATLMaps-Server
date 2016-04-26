class RasterLayerProjectSerializer < ActiveModel::Serializer

  # has_one :raster_layer, embed: :id, :include => true
  # has_one :project

  attributes :id, :project_id, :data_format, :position, :raster_layer_id


end
