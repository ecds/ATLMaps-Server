class AddFieldsToVectroRasterJoins < ActiveRecord::Migration
  def change
  	add_column :vector_layer_projects, :position, :integer, :after => :project_id
  	add_column :raster_layer_projects, :position, :integer, :after => :project_id
  	add_column :vector_layer_projects, :layer_type, :string, :after => :project_id
  	add_column :raster_layer_projects, :layer_type, :string, :after => :project_id
  	add_column :raster_layer_projects, :marker, :integer, :after => :project_id
  end
end
