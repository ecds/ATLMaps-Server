class ChangeStatusAndAddPublished < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :published, :boolean, default: false, :after => :status
    change_column :projects, :status, 'boolean USING CAST(status AS boolean)', default: false
  end
end
