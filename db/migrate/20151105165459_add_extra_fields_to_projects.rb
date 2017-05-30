class AddExtraFieldsToProjects < ActiveRecord::Migration[4.2]
  def change
  	add_column :projects, :details, :text
  	add_column :projects, :media, :string 
  end
end
