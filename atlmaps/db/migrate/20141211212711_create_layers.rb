class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.string :slug
      t.string :keywords
      t.string :description
      t.string :url
      t.string :layer
      t.datetime :date
      t.string :layer_type
      t.string :zoomlevels
      t.decimal :minx, :precision => 10, :scale => 8
      t.decimal :miny, :precision => 10, :scale => 8
      t.decimal :maxx, :precision => 10, :scale => 8
      t.decimal :maxy, :precision => 10, :scale => 8
      t.timestamps
    end
  end
end
