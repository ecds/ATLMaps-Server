# frozen_string_literal: true

# Initializer to set the default spactial factory
FACTORY = RGeo::Geographic.simple_mercator_factory

RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  # By default, use the GEOS implementation for spatial columns.
  config.default = FACTORY

  # But use a geographic implementation for polygon columns.
  config.register(RGeo::Geographic.simple_mercator_factory.projection_factory, geo_type: 'polygon')
  # config.register(RGeo::Geographic.simple_mercator_factory.projection_factory, geo_type: 'point')
end

# SELECT raster_layers.title, raster_layers.id , neighborhoods.id, neighborhoods.name
# FROM raster_layers INNER JOIN neighborhoods
# ON  st_intersects(raster_layers.boundingbox, neighborhoods.polygon ) where neighborhoods.id = 37
# order by st_area(st_intersection(raster_layers.boundingbox, neighborhoods.polygon)),
# st_distance(ST_Centroid(neighborhoods.polygon), ST_Centroid(raster_layers.boundingbox))
