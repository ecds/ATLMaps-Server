class RasterLayerProject < ActiveRecord::Base
  belongs_to :raster_layer
  belongs_to :project

  default_scope {order("raster_layer_projects.position DESC") }
end
