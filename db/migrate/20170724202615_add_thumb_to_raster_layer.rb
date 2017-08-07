class AddThumbToRasterLayer < ActiveRecord::Migration[5.1]
  def change
    add_column :raster_layers, :thumb, :string
  end
end
