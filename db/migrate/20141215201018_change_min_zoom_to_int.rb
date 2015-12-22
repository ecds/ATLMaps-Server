class ChangeMinZoomToInt < ActiveRecord::Migration
  def change
    # change_column :layers, :minzoom, 'integer USING CAST(minzoom AS integer)'
  end
end
