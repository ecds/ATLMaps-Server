class CreateProjectlayerJoin < ActiveRecord::Migration
  def change
    create_table :projectlayers do |t|
      t.belongs_to :layer
      t.belongs_to :project
      t.timestamps
    end
    add_index :projectlayers, :layer_id
    add_index :projectlayers, :project_id
  end
end