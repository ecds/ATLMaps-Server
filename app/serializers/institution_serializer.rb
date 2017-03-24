class InstitutionSerializer < ActiveModel::Serializer
    attributes :id, :name, :slug, :icon, :geoserver
end
