class ProjectSerializer < ActiveModel::Serializer
  
  has_many :layers, embed: :ids
  has_many :raster_layers, embed: :ids
  has_many :vector_layers, embed: :ids
  has_many :users, embed: :ids
  
  attributes  :id,
        			:name,
        			:description,
              :center_lat,
              :center_lng,
              :zoom_level,
        			:saved,
        			:published,
        			:slug,
        			:user_id,
        			:user,
        			:owner,
        			:layer_ids,
              :raster_layer_ids,
              :vector_layer_ids,
        			:is_mine,
              :may_edit,
              :user_ids

  def is_mine
	  return options[:resource_owner] == self.user_id
  end

  def may_edit
    if self.user_ids.include? options[:resource_owner]
      return true
    else
      return self.is_mine
    end
  end
end
