class CreateCollaboration < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.belongs_to :project
      t.belongs_to :user
      t.timestamps
    end
    add_index :collaborations, :project_id
    add_index :collaborations, :user_id
  end
end
