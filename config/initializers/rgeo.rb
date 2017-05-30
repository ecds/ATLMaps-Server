# Initializer to set the default spactial factory
#
RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
    # By default, use the GEOS implementation for spatial columns.
    config.default = RGeo::Geos.factory_generator

    # But use a geographic implementation for polygon columns.
    config.register(RGeo::Geographic.simple_mercator_factory(srid: 4326), geo_type: 'polygon')
    config.register(RGeo::Geographic.simple_mercator_factory(srid: 4326), geo_type: 'point')
end

# SELECT raster_layers.title, raster_layers.id , neighborhoods.id, neighborhoods.name
# FROM raster_layers INNER JOIN neighborhoods
# ON  st_intersects(raster_layers.boundingbox, neighborhoods.polygon ) where neighborhoods.id = 37
# order by st_area(st_intersection(raster_layers.boundingbox, neighborhoods.polygon)),
# st_distance(ST_Centroid(neighborhoods.polygon), ST_Centroid(raster_layers.boundingbox))
