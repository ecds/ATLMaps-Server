class Tag < ActiveRecord::Base

  has_and_belongs_to_many :layers, dependent: :destroy
  has_and_belongs_to_many :raster_layers, -> { distinct }, dependent: :destroy
  has_and_belongs_to_many :vector_layers, -> { distinct }, dependent: :destroy

  has_and_belongs_to_many :categories

  def slug
    self.name.parameterize
  end
end
