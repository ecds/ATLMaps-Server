# frozen_string_literal: true

# Base serializer for vector and raster layers.
class LayerSerializer < ActiveModel::Serializer
  belongs_to :institution
  has_many :tags

  attributes  :id,
              :name,
              :title,
              :keywords,
              :description,
              :url,
              :date,
              :year,
              :minzoom,
              :maxzoom,
              :minx,
              :miny,
              :maxx,
              :maxy,
              :boundingbox,
              :active,
              :attribution
end
