class CreateVectorFeatures < ActiveRecord::Migration[5.0]
    def up
        create_table :vector_features do |t|
            t.string :name
            t.json :properties
            t.string :geometry_type
            t.geometry_collection :geometry_collection
            t.references :vector_layer
        end
    end

    def down
        drop_table :features
    end
end
