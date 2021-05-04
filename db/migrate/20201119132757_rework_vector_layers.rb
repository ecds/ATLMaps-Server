class ReworkVectorLayers < ActiveRecord::Migration[6.0]
  def change
    rename_column :vector_layers, :data_type, :tmp_type
    add_column :vector_layers, :data_type, :integer
    add_column :vector_layers, :geometry_type, :integer
  end
end
