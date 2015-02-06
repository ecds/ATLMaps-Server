class InstitutionSerializer < ActiveModel::Serializer
  
  has_many :layers, embed: :ids
  
  attributes :id, :name, :slug, :icon, :geoserver
  
end
