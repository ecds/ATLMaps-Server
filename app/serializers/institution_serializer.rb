# frozen_string_literal: true

# Serializer for institutions.
class InstitutionSerializer < ActiveModel::Serializer
  # has_many :raster_layers
  # has_many :vector_layers
  attributes :id, :name, :slug, :icon, :geoserver
end
