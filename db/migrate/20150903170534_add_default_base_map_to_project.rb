class AddDefaultBaseMapToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :default_base_map, :string, :null => false, :default => 'street', :after => :zoom_level
  end
end
