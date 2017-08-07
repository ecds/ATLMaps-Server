class AddAttributionToLayers < ActiveRecord::Migration[5.1]
  def change
      add_column :raster_layers, :attribution, :string
      add_column :vector_layers, :attribution, :string

  end
end
