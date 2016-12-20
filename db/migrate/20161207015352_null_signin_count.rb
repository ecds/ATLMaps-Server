class NullSigninCount < ActiveRecord::Migration
  def change
      change_column :users, :sign_in_count, :integer, :null => true
  end
end
