class VectorLayer < ActiveRecord::Base

  has_many :vector_layer_project
  has_many :projects, through: :vector_layer_project, dependent: :destroy
  belongs_to :institution
  
  has_and_belongs_to_many :tags, dependent: :destroy

  #default_scope {includes(:projectlayer)}
  
  # Attribute to use for html classes
  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end

end
