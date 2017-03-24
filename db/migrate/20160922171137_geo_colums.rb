class GeoColums < ActiveRecord::Migration
  def change
    add_column :raster_layers, :boundingbox, :st_polygon, geographic: false, srid: 3857
    add_index :raster_layers, :boundingbox, using: :gist
  end
end