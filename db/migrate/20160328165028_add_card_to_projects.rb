class AddCardToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :card, :string
  end
end
