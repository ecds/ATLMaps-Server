class MapLayerSerializer < ActiveModel::Serializer
    attributes :raster_layer_ids, :vector_layer_ids
end
