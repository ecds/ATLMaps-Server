class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :layers, dependent: :destroy
  has_and_belongs_to_many :raster_layers, dependent: :destroy
  has_and_belongs_to_many :vector_layers, dependent: :destroy
  
  def slug
    self.name.parameterize
  end
end
