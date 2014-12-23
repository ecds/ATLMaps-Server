class AddInstitutionIcon < ActiveRecord::Migration
  def change
    add_column :institutions, :icon, :string, :after => :geoserver
  end
end
