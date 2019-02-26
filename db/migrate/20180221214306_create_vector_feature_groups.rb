class CreateVectorFeatureGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :vector_feature_groups do |t|
        t.belongs_to :vector_layer, index: true
        t.string :filter_name
      t.timestamps
    end

    create_table :vector_feature_group_features do |t|
      t.belongs_to :vector_features, index: true
      t.belongs_to :vector_feature_groups, index: true
      t.string :filter_value
      t.timestamps
    end
  end
end
