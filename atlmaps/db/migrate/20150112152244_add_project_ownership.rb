class AddProjectOwnership < ActiveRecord::Migration
  def change
    add_reference :projects, :user, index: true, :after => :published
  end
end
