class FixZoomLevels < ActiveRecord::Migration
  def change
    # rename_column :layers, :zoomlevels, :minzoom
    # add_column :layers, :maxzoom, :integer, :after => :minzoom
  end
end
