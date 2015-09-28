class RasterLayer < ActiveRecord::Base

  has_many :raster_layer_project
  has_many :projects, through: :raster_layer_project, dependent: :destroy
  belongs_to :institution

  has_and_belongs_to_many :tags, dependent: :destroy

  include PgSearch
  pg_search_scope :search, against: [:name, :description],
    using: { tsearch: { dictionary: 'english' } },
    associated_against: { tags: :name, institution: :name }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  # Attribute to use for html classes
  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end

  def slider_id
  	slug = self.name.parameterize
  	return "slider-#{slug}-#{id}"
  end

  def slider_value_id
  	slug = self.name.parameterize
  	return "slider-value-#{slug}-#{id}"
  end

end
