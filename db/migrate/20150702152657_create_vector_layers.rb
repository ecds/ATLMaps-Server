class CreateVectorLayers < ActiveRecord::Migration[4.2]
  def change
    create_table :vector_layers do |t|
    	t.string :name
		t.string :slug
		t.string :keywords
		t.string :description
		t.string :url
		t.string :layer
		t.datetime :date
		t.string :layer_type
		t.integer :minzoom
		t.integer :maxzoom
		t.decimal :minx, :precision => 10, :scale => 8
		t.decimal :miny, :precision => 10, :scale => 8
		t.decimal :maxx, :precision => 10, :scale => 8
		t.decimal :maxy, :precision => 10, :scale => 8
		t.boolean :active, default: true
		t.references(:institution, index: true)
		t.timestamps
    end
  end
end
