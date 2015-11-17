class CreatingLongIntros < ActiveRecord::Migration
  def change
      create_table :templates do |t|
          t.string :name
      end
      change_column :projects, :featured, :boolean, after: :published
      change_column :projects, :details, :text, after: :description
      change_column :projects, :media, :text, after: :details
      rename_column :projects, :details, :intro

      add_reference :projects, :template, index: true, after: :media
  end
end
