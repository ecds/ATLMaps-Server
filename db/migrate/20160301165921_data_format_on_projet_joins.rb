class DataFormatOnProjetJoins < ActiveRecord::Migration[4.2]
  def change
      rename_column :raster_layer_projects, :layer_type, :data_format
      rename_column :vector_layer_projects, :layer_type, :data_format
  end
end
