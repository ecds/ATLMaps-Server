class DataFormatOnProjetJoins < ActiveRecord::Migration
  def change
      rename_column :raster_layer_projects, :layer_type, :data_format
      rename_column :vector_layer_projects, :layer_type, :data_format
  end
end
