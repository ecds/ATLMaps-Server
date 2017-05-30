class IncreaseRasterDescriptionLimit < ActiveRecord::Migration[4.2]
  def change
      change_column :raster_layers, :description, :string, :limit => 500
  end
end
