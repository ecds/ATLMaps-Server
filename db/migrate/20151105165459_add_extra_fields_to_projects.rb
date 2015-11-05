class AddExtraFieldsToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :details, :text
  	add_column :projects, :media, :string 
  end
end
