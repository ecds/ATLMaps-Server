class CreateInstitutions < ActiveRecord::Migration[4.2]
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :geoserver
      t.timestamps
    end
  end
end
