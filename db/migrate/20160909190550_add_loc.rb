class AddLoc < ActiveRecord::Migration[4.2]
  def change
    add_column :tags, :heading, :string
    add_column :tags, :loclink, :string
  end
end
