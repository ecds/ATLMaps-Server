class Layer < ActiveRecord::Base

  has_many :projectlayer
  has_many :projects, through: :projectlayer, dependent: :destroy
  belongs_to :institution
  
  has_and_belongs_to_many :tags, dependent: :destroy
  
  # Attribute to use for html classes
  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end
  
  def institution_slug
    return self.institution.name.parameterize
  end

end
