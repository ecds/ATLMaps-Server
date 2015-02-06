class AddLayerTypeToProjectLayer < ActiveRecord::Migration
  def change
    add_column :projectlayers, :layer_type, :string, :after => :marker
  end
end
