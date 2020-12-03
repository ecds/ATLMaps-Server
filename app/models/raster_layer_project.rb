# frozen_string_literal: true

class RasterLayerProject < ApplicationRecord
  belongs_to :raster_layer
  belongs_to :project

  after_create :set_position

  default_scope { order('raster_layer_projects.position DESC') }

  private

  def set_position
    return if position.present?

    self.position = project.raster_layers.length + 11
    save
  end
end
