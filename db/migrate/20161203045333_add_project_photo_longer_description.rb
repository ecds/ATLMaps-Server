class AddProjectPhotoLongerDescription < ActiveRecord::Migration
  def change
      change_column :projects, :description, :string, :limit => 500
      add_column :projects, :photo, :string
  end
end
