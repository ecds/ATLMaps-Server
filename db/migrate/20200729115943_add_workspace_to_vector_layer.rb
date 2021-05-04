class AddWorkspaceToVectorLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layers, :workspace, :string
  end
end
