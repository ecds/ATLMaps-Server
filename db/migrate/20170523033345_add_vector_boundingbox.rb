class AddVectorBoundingbox < ActiveRecord::Migration[5.0]
  def change
      add_column :vector_layers, :boundingbox, :st_polygon, geographic: false, srid: 4326
  end
end
