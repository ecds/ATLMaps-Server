class AddOrderToVectorLayerProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layer_projects, :order, :integer
  end
end
