class MakeObjectsGeo < ActiveRecord::Migration[5.1]
  def change
    enable_extension "postgis"
    change_column :vector_layers, :boundingbox, :st_polygon, srid: 3857
    change_column :raster_layers, :boundingbox, :st_polygon, srid: 3857
    change_column :vector_features, :geometry_collection, :geometry_collection, srid: 3857
  end
end
