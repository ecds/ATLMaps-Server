class GeoColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :vector_features, :point, :st_point, geographic: false, srid: 4326
    add_column :vector_features, :multi_point, :multi_point, geographic: false, srid: 4326
    add_column :vector_features, :polygon, :st_polygon, geographic: false, srid: 4326
    add_column :vector_features, :multi_polygon, :multi_polygon, geographic: false, srid: 4326
    add_column :vector_features, :line_string, :line_string, geographic: false, srid: 4326
    add_column :vector_features, :multi_line_string, :multi_line_string, geographic: false, srid: 4326
  end
end
