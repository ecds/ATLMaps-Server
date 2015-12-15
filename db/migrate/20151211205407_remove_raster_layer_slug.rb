class RemoveRasterLayerSlug < ActiveRecord::Migration
  def change
      remove_column :raster_layers, :slug
  end
end
