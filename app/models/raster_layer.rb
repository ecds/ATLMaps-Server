class RasterLayer < ActiveRecord::Base
  # include Filtering
  has_many :raster_layer_project
  has_many :projects, through: :raster_layer_project, dependent: :destroy
  belongs_to :institution

  has_and_belongs_to_many :tags, dependent: :destroy

  scope :by_institution, ->(name) { joins(:institution).where(institutions: {name: name}) if name.present?}
  scope :by_tags, -> (tags){ joins(:tags).where(tags: {name: tags}) if tags.present?}
  scope :by_date, ->(start_date,end_date) { where(date: start_date..end_date) if start_date.present? and end_date.present?}

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
