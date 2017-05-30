class ChangeStatusToSaved < ActiveRecord::Migration[4.2][4.2]
  def change
    rename_column :projects, :status, :saved
  end
end
