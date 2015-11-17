class Project < ActiveRecord::Base

  belongs_to :user

  belongs_to :template

  has_many :projectlayer
  has_many :layers, through: :projectlayer, dependent: :destroy

  has_many :raster_layer_project
  has_many :raster_layers, through: :raster_layer_project, dependent: :destroy

  has_many :vector_layer_project
  has_many :vector_layers, through: :vector_layer_project, dependent: :destroy

  has_many :collaboration
  has_many :users, through: :collaboration

  # default_scope {includes(:projectlayer)}
  # validates_format_of :media, :with => /(?:.be\/|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/, :on => :create, if: 'media.present?'
  validates :media, format: { with: /(?:.be\/|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/,
    message: "Not a valid YouTube embed code." }, if: 'media.present?'

  def slug
    return self.name.parameterize
  end

  def owner
    return self.user.displayname
  end

  # I don't think this is needed anymore
  # def self.find_by_param(input)
  #   find_by_slug(input)
  # end

end
