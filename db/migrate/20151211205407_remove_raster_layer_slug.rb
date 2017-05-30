class RemoveRasterLayerSlug < ActiveRecord::Migration[4.2]
  def change
      remove_column :raster_layers, :slug
  end
end
