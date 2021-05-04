class AddPropertyIdToVectorLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layers, :property_id, :string
  end
end
