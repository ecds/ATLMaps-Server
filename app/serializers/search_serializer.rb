class SearchSerializer < RasterLayerSerializer
  # ActiveModel::Serializer.config.adapter = :json

   # has_many :layers, embed: :ids
   # has_many :vectors, embed: :ids

   attributes :id

end
