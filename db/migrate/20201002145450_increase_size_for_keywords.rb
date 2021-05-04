class IncreaseSizeForKeywords < ActiveRecord::Migration[6.0]
  def change
    change_column :layers, :keywords, :text
    change_column :raster_layers, :keywords, :text
    change_column :vector_layers, :keywords, :text
  end
end
