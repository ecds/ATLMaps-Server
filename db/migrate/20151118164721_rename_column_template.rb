class RenameColumnTemplate < ActiveRecord::Migration
  def change
  	rename_column :projects, :templates_id, :template_id
  end
end
