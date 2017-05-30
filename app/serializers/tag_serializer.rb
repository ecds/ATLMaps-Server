class TagSerializer < ActiveModel::Serializer
    # has_many :vector_layers, embed: :ids
    # has_many :raster_layers
    # has_many :categories, embed: :ids
    attributes  :id,
                :name,
                :heading,
                :slug
    def slug
        return :name.to_param
    end
end
