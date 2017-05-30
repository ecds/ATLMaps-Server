class ExtendUserModel < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :username, :string, :after => :id
    add_column :users, :displayname, :string, :after => :username
    add_column :users, :avatar, :string, :after => :email
    add_column :users, :twitter, :string, :after => :avatar
  end
end
