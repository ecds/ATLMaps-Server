class Tag < ActiveRecord::Base
  
  has_and_belongs_to_many :layers, dependent: :destroy
  
  def slug
    self.name.parameterize
  end
end
