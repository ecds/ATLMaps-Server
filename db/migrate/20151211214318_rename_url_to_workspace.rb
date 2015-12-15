class RenameUrlToWorkspace < ActiveRecord::Migration
  def change
      rename_column :raster_layers, :url, :workspace
  end
end
