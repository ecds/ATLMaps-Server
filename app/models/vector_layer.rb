class VectorLayer < ActiveRecord::Base
  # include Filtering
  has_many :vector_layer_project
  has_many :projects, through: :vector_layer_project, dependent: :destroy
  belongs_to :institution

  has_and_belongs_to_many :tags, dependent: :destroy

  scope :by_institution, ->(name) { joins(:institution).where(institutions: {name: name}) if name.present?}
  scope :by_tags, -> (tags){ joins(:tags).where(tags: {name: tags}) if tags.present?}
  scope :by_date, ->(start_date,end_date) { where(date: start_date..end_date) if start_date.present? and end_date.present?}

#default_scope {includes(:projectlayer)}

  # Attribute to use for html classes
  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end

end
