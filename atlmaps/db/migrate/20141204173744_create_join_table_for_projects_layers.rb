class CreateJoinTableForProjectsLayers < ActiveRecord::Migration
  def change
    create_table :layers_projects, id: false do |t|
      t.belongs_to :layer
      t.belongs_to :project
    end
  end
end