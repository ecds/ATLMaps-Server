class FixBooleanForPostgres < ActiveRecord::Migration[4.2]
  def change
    # execute %q(ALTER TABLE "projects" ALTER COLUMN "published" DROP DEFAULT;)
    # execute %q(ALTER TABLE "raster_layers" ALTER COLUMN "active" DROP DEFAULT;)
    # execute %q(ALTER TABLE "vector_layers" ALTER COLUMN "active" DROP DEFAULT;)
    #
    # execute %q(ALTER TABLE "projects" ALTER "published" TYPE bool USING CASE WHEN published=0 THEN FALSE ELSE TRUE END;)
    # execute %q(ALTER TABLE "raster_layers" ALTER "published" TYPE bool USING CASE WHEN active=0 THEN FALSE ELSE TRUE END;)
    # execute %q(ALTER TABLE "vector_layers" ALTER "published" TYPE bool USING CASE WHEN active=0 THEN FALSE ELSE TRUE END;)
    #
    # change_column :projects, :published, :boolean, :default => false
    # change_column :raster_layers, :active, :boolean, :default => false
    # change_column :vector_layers, :active, :boolean, :default => false

  end
end
