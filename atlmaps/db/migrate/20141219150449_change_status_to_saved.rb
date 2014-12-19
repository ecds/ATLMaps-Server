class ChangeStatusToSaved < ActiveRecord::Migration
  def change
    rename_column :projects, :status, :saved
  end
end
