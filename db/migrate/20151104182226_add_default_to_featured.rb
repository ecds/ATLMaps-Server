class AddDefaultToFeatured < ActiveRecord::Migration[4.2]
  def change
  	change_column :projects, :featured, :boolean, :default => false
  end
end
