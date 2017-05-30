class CreateVectorLayerProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :vector_layer_projects do |t|
      t.belongs_to :vector_layer
      t.belongs_to :project
      t.timestamps
    end
    add_index :vector_layer_projects, :vector_layer_id
    add_index :vector_layer_projects, :project_id
  end
end
