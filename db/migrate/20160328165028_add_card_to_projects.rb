class AddCardToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :card, :string
  end
end
