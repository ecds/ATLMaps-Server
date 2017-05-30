class AddTitileToVectorLayhers < ActiveRecord::Migration[4.2]
  def change
      add_column :vector_layers, :title, :string, after: :name
  end
end
