class CreateUserTaggeds < ActiveRecord::Migration
  def change
    create_table :user_taggeds do |t|
      t.belongs_to :raster_layer, index: true
      t.belongs_to :vector_layer, index: true
      t.belongs_to :tag, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
