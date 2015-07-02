class CreateVectorLayerTags < ActiveRecord::Migration
  def change
    create_table :tags_vector_layers do |t|
      t.belongs_to :vector_layer, index: true
      t.belongs_to :tag, index: true
    end
  end
end
