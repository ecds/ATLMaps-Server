class CreateNeighborhoods < ActiveRecord::Migration[4.2]
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.multi_polygon :polygon, geographic: false, srid: 3857
      t.timestamps null: false
    end
  end
end
