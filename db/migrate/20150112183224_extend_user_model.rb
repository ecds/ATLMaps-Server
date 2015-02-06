class ExtendUserModel < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, :after => :id
    add_column :users, :displayname, :string, :after => :username
    add_column :users, :avatar, :string, :after => :email
    add_column :users, :twitter, :string, :after => :avatar
  end
end
