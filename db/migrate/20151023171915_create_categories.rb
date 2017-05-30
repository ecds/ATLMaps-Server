class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :categories_tags, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :tag, index: true
    end

  end
end
