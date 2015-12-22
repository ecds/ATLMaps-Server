class DropProjectLayersTable < ActiveRecord::Migration
  def change
      drop_table :projectlayers
  end
end
