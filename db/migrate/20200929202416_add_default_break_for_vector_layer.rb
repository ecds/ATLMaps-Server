class AddDefaultBreakForVectorLayer < ActiveRecord::Migration[6.0]
  def change
    add_column :vector_layers, :default_break_property, :string
  end
end
