class Tag < ApplicationRecord
    has_and_belongs_to_many :layers, dependent: :destroy
    has_and_belongs_to_many :raster_layers, -> { distinct }, dependent: :destroy
    has_and_belongs_to_many :vector_layers, -> { distinct }, dependent: :destroy

    has_and_belongs_to_many :categories

    def slug
        name.parameterize
    end
end
