class RemoveVectorLayerSlug < ActiveRecord::Migration[4.2]
  def change
      remove_column :vector_layers, :slug
  end
end
