class Institution < ActiveRecord::Base
  has_many :users
  has_many :vector_layers
  has_many :raster_layers

  def slug
    return self.name.parameterize
  end

end
