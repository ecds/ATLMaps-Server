class DataTypeAndDataFormat < ActiveRecord::Migration
  def change
      rename_column :raster_layers, :layer_type, :data_format
      rename_column :vector_layers, :layer_type, :data_format
      add_column :raster_layers, :data_type, :string
      add_column :vector_layers, :data_type, :string
  end
end
