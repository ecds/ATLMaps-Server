class UserTagged < ActiveRecord::Base
  belongs_to :raster_layer
  belongs_to :vector_layer
  belongs_to :tag
  belongs_to :user

  after_save do
    count = UserTagged \
      .where(raster_layer_id: self.raster_layer_id) \
      .where(tag_id: self.tag_id) \
      .count

    if count >= 2
      raster = RasterLayer.find(self.raster_layer_id)
      raster.tags << Tag.find(self.tag_id)
      raster.save
    # else
    end
  end
end
