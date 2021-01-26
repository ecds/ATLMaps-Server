class AddDataFormatToRasters < ActiveRecord::Migration[6.0]
  def change
    add_column :raster_layers, :data_format, :integer, default: 0
  end
end
