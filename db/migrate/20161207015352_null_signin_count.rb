class NullSigninCount < ActiveRecord::Migration[4.2]
  def change
      change_column :users, :sign_in_count, :integer, :null => true
  end
end
