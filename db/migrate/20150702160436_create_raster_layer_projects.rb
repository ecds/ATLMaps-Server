class CreateRasterLayerProjects < ActiveRecord::Migration
  def change
    create_table :raster_layer_projects do |t|
      t.belongs_to :raster_layer
      t.belongs_to :project
      t.timestamps
    end
    add_index :raster_layer_projects, :raster_layer_id
    add_index :raster_layer_projects, :project_id
  end
end
