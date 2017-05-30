class CreateVectorLayerTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags_vector_layers do |t|
      t.belongs_to :vector_layer, index: true
      t.belongs_to :tag, index: true
    end
  end
end
