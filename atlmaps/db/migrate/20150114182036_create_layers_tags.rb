class CreateLayersTags < ActiveRecord::Migration
  def change
    create_table :layers_tags, id: false do |t|
      t.belongs_to :layer, index: true
      t.belongs_to :tag, index: true
    end
  end
end
