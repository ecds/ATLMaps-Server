class AddColormapToVectorLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layers, :color_map, :jsonb
  end
end
