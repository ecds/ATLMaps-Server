class RasterLayer < ActiveRecord::Base

  has_many :raster_layer_project
  has_many :projects, through: :raster_layer_project, dependent: :destroy
  belongs_to :institution
  
  has_and_belongs_to_many :tags, dependent: :destroy

  #default_scope :include => raster_layer_projects#, :order => "raster_layer_projects.position DESC"
  
  # Attribute to use for html classes
  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end

  def slider_id
  	slug = self.name.parameterize
  	return "slider-#{slug}-#{id}"
  end

  def slider_value_id
  	slug = self.name.parameterize
  	return "slider-value-#{slug}-#{id}"
  end

end
