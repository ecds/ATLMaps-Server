class AddColorMapFlagsToVectorLayerProject < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layer_projects, :brewer_group, :string
    add_column :vector_layer_projects, :manual_steps, :boolean
  end
end
