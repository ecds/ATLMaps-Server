class UserTaggdSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :raster_layer_id, :vector_layer_id, :user_id
end
