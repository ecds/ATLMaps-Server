class AddTitileToVectorLayhers < ActiveRecord::Migration
  def change
      add_column :vector_layers, :title, :string, after: :name
  end
end
