class InstitutionSerializer < ActiveModel::Serializer

  ActiveModel::Serializer.config.adapter = :json

  has_many :users, embed: :ids

  attributes :id, :name, :slug, :icon, :geoserver

end
