class AddProjectPhotoLongerDescription < ActiveRecord::Migration[4.2]
  def change
      change_column :projects, :description, :string, :limit => 500
      add_column :projects, :photo, :string
  end
end
