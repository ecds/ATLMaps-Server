class UserTagged < ActiveRecord::Base
    belongs_to :raster_layer
    belongs_to :vector_layer
    belongs_to :tag
    belongs_to :user

    # validates :user_id, uniqueness: { scope: [:raster_layer_id, :tag_id] }

    after_save do
        count = UserTagged.where(raster_layer_id: raster_layer_id)
                          .where(tag_id: tag_id).count
        if count >= 2
            raster = RasterLayer.find(raster_layer_id)
            raster.tags << Tag.find(tag_id)
            raster.save
            # else
        end
    end
end
