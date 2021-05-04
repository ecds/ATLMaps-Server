class AddTmpGeojson < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layers, :tmp_geojson, :jsonb
  end
end
