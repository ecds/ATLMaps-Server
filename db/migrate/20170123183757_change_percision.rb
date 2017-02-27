class ChangePercision < ActiveRecord::Migration[5.0]
  def change
      change_column :vector_layers, :maxx, :decimal, precision: 100, scale: 8
      change_column :vector_layers, :maxy, :decimal, precision: 100, scale: 8
      change_column :vector_layers, :minx, :decimal, precision: 100, scale: 8
      change_column :vector_layers, :miny, :decimal, precision: 100, scale: 8
      change_column :raster_layers, :maxx, :decimal, precision: 100, scale: 8
      change_column :raster_layers, :maxy, :decimal, precision: 100, scale: 8
      change_column :raster_layers, :minx, :decimal, precision: 100, scale: 8
      change_column :raster_layers, :miny, :decimal, precision: 100, scale: 8
  end
end
