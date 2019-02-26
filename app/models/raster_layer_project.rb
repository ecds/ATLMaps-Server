class RasterLayerProject < ApplicationRecord
    belongs_to :raster_layer
    belongs_to :project

    after_create do
        return if position.present?
        self.position = project.raster_layers.length + 11
        save
    end

    default_scope { order('raster_layer_projects.position DESC') }
end
