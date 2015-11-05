class AddDefaultToFeatured < ActiveRecord::Migration
  def change
  	change_column :projects, :featured, :boolean, :default => false
  end
end
