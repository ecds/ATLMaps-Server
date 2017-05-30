class RasterLayerProjectSerializer < ActiveModel::Serializer
    belongs_to :raster_layer, serializer: RasterLayerSerializer
    belongs_to :project

    attributes :id, :data_format, :position
end
