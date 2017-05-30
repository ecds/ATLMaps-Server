class RemoveUnneededLayerColums < ActiveRecord::Migration[4.2]
  def change
      rename_column :raster_layers, :layer, :title
      remove_column :vector_layers, :layer
  end
end
