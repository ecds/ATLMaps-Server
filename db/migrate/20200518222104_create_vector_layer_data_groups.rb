class CreateVectorLayerDataGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layer_projects, :brewer_scheme, :string
    add_column :vector_layer_projects, :property, :string
    add_column :vector_layer_projects, :steps, :integer
    add_column :vector_layer_projects, :color_map, :jsonb, default: {}
  end
end
