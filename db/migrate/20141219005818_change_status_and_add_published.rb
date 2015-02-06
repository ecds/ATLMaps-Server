class ChangeStatusAndAddPublished < ActiveRecord::Migration
  def change
    add_column :projects, :published, :boolean, default: false, :after => :status
    change_column :projects, :status, :boolean, default: false
  end
end