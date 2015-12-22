class InstitutionSerializer < ActiveModel::Serializer
    
  has_many :users, embed: :ids

  attributes :id, :name, :slug, :icon, :geoserver

end
