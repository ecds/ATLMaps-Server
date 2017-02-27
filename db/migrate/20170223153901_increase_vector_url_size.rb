class IncreaseVectorUrlSize < ActiveRecord::Migration[5.0]
  def change
      change_column :vector_layers, :url, :string, :limit => 500
  end
end
