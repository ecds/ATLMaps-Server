class AddInstitutionIcon < ActiveRecord::Migration[4.2]
  def change
    add_column :institutions, :icon, :string, :after => :geoserver
  end
end
