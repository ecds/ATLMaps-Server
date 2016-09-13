class LayerDescriptionToText < ActiveRecord::Migration
  def change
    change_column :raster_layers, :description, :text, :limit =>nil
    change_column :vector_layers, :description, :text, :limit =>nil
  end
end
