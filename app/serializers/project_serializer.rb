class ProjectSerializer < ActiveModel::Serializer
  
  has_many :layers, embed: :ids
  has_many :raster_layers, embed: :ids
  has_many :vector_layers, embed: :ids
  has_many :users, embed: :ids
  
  attributes :id,
  			:name,
  			:description,
  			:saved,
  			:published,
  			:slug,
  			:user_id,
  			:user,
  			:owner,
  			:layer_ids,
        :raster_layer_ids,
        :vector_layer_ids,
  			:is_mine

  def is_mine
	  # if options[:resource_owner] == self.user_id
	  #   return true
	  # else
	  #   return false
	  # end
	  return options[:resource_owner] == self.user_id
  end

end