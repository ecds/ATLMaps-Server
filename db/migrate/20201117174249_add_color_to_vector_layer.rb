class AddColorToVectorLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layer_projects, :color, :text
  end
end
