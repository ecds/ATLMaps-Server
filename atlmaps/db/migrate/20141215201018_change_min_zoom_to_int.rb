class ChangeMinZoomToInt < ActiveRecord::Migration
  def change
    change_column :layers, :minzoom, :integer
  end
end
