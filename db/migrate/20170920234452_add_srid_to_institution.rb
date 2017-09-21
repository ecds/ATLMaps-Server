class AddSridToInstitution < ActiveRecord::Migration[5.1]
  def change
    add_column :institutions, :srid, :string
  end
end
