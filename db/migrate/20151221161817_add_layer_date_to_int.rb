class AddLayerDateToInt < ActiveRecord::Migration
  def change
      add_column :raster_layers, :year, :integer, after: :date
      add_column :vector_layers, :year, :integer, after: :date
  end
end
