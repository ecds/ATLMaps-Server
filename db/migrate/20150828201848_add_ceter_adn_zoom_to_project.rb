class AddCeterAdnZoomToProject < ActiveRecord::Migration[4.2]
  def change
  	add_column :projects, :center_lat, :decimal, :precision => 10, :scale => 8, :null => false, :default => 33.75440100, :after => :description
  	add_column :projects, :center_lng, :decimal, :precision => 10, :scale => 8, :null => false, :default => -84.3898100, :after => :center_lat
  	add_column :projects, :zoom_level, :integer, :null => false, :default => 13, :after => :center_lng
  end
end
