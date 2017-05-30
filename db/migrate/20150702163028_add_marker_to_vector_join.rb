class AddMarkerToVectorJoin < ActiveRecord::Migration[4.2]
  def change
  	add_column :vector_layer_projects, :marker, :integer, :after => :project_id
  end
end
