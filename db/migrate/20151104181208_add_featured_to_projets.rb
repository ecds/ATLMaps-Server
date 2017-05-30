class AddFeaturedToProjets < ActiveRecord::Migration[4.2]
  def change
  	add_column :projects, :featured, :boolean
  end
end
