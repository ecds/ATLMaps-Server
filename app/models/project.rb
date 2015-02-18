class Project < ActiveRecord::Base

  has_many :projectlayer
  has_many :layers, through: :projectlayer, dependent: :destroy
  belongs_to :user
  has_many :collaboration
  has_many :users, through: :collaboration, dependent: :destroy
  
  def slug
    return self.name.parameterize
  end
  
  def owner
    return self.user.displayname
  end

end

