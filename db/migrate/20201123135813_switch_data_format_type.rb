class SwitchDataFormatType < ActiveRecord::Migration[6.0]
  def change
    remove_column :vector_layers, :data_format
    add_column :vector_layers, :data_format, :integer
  end
end
