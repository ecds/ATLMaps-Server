class LayerDescriptionToText < ActiveRecord::Migration[4.2]
  def change
    change_column :raster_layers, :description, :text, :limit =>nil
    change_column :vector_layers, :description, :text, :limit =>nil
  end
end
