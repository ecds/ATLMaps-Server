class Institution < ActiveRecord::Base
  has_many :layers
  has_many :users
  
  def slug
    return self.name.parameterize
  end
  
end
