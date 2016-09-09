class AddLoc < ActiveRecord::Migration
  def change
    add_column :tags, :heading, :string
    add_column :tags, :loclink, :string
  end
end
