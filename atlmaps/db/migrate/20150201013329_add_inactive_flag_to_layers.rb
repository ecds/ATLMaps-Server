class AddInactiveFlagToLayers < ActiveRecord::Migration
  def change
    add_column :layers, :active, :boolean, :default => true, :after => :maxy
  end
end
