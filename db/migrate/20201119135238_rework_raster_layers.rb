class ReworkRasterLayers < ActiveRecord::Migration[6.0]
  def change
    remove_column :raster_layers, :data_type
    remove_column :raster_layers, :data_format
  end
end
