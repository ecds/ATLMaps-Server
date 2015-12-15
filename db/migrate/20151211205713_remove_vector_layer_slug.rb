class RemoveVectorLayerSlug < ActiveRecord::Migration
  def change
      remove_column :vector_layers, :slug
  end
end
