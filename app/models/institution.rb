class Institution < ApplicationRecord
    has_many :users
    has_many :vector_layers
    has_many :raster_layers

    def slug
        return name.parameterize
    end
end
