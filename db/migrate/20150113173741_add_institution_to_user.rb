class AddInstitutionToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :institution, index: true, :after => :email
  end
end
