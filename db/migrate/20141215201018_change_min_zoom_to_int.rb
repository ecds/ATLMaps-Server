class ChangeMinZoomToInt < ActiveRecord::Migration[4.2]
  def change
    # change_column :layers, :minzoom, 'integer USING CAST(minzoom AS integer)'
  end
end
