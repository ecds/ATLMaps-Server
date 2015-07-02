class AddPositionToProjectLayer < ActiveRecord::Migration
  def change
  	add_column :projectlayers, :position, :integer, :after => :project_id
  end
end
