class AddGeojosnToVectorLayers < ActiveRecord::Migration[5.1]
  def change
    add_column :vector_layers, :geojson, :json
  end
end
