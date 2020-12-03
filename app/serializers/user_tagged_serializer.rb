# frozen_string_literal: true

class UserTaggedSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :raster_layer_id, :vector_layer_id, :user_id, :tag_id
end
