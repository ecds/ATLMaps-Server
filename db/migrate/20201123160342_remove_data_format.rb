class RemoveDataFormat < ActiveRecord::Migration[6.0]
  def change
    remove_column :vector_layer_projects, :data_format
  end
end
