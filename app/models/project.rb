class Project < ActiveRecord::Base

  has_many :projectlayer
  has_many :layers, through: :projectlayer, dependent: :destroy

  has_many :raster_layer_project
  has_many :raster_layers, through: :raster_layer_project, dependent: :destroy

  has_many :vector_layer_project
  has_many :vector_layers, through: :vector_layer_project, dependent: :destroy

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
