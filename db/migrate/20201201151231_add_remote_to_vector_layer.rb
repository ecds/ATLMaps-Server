class AddRemoteToVectorLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layers, :remote, :boolean
  end
end
