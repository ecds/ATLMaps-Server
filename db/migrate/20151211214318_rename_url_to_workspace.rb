class RenameUrlToWorkspace < ActiveRecord::Migration[4.2]
  def change
      rename_column :raster_layers, :url, :workspace
  end
end
