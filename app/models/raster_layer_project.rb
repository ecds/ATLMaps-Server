class RasterLayerProject < ActiveRecord::Base
  belongs_to :raster_layer
  belongs_to :project

  default_scope {order("position DESC") }
end
