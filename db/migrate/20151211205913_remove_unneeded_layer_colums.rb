class RemoveUnneededLayerColums < ActiveRecord::Migration
  def change
      remove_column :raster_layers, :layer
      remove_column :vector_layers, :layer
  end
end
