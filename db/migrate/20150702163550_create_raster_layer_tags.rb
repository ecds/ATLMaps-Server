class CreateRasterLayerTags < ActiveRecord::Migration[4.2]
  def change
    create_table :raster_layers_tags do |t|
      t.belongs_to :raster_layer, index: true
      t.belongs_to :tag, index: true
    end
  end
end
