class IncreaseRasterDescriptionLimit < ActiveRecord::Migration
  def change
      change_column :raster_layers, :description, :string, :limit => 500
  end
end
