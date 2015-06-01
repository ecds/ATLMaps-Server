class Project < ActiveRecord::Base

  has_many :projectlayer
  has_many :layers, through: :projectlayer, dependent: :destroy
  belongs_to :user
  has_many :collaboration
  has_many :users, through: :collaboration#, dependent: :destroy

  default_scope {includes(:projectlayer)}
  
  def slug
    return self.name.parameterize
  end
  
  def owner
    if self.user
      return self.user.displayname
    else
      return 'Guest'
    end
  end

  def self.find_by_param(input)
    find_by_slug(input)
  end

end
