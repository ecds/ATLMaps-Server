# Base serializer for vector and raster layers.
class LayerSerializer < ActiveModel::Serializer
    belongs_to :institution
    has_many :tags

    attributes  :id,
                :name,
                :title,
                :slug,
                :keywords,
                :description,
                :url,
                :date,
                :year,
                :data_format,
                :data_type,
                :minzoom,
                :maxzoom,
                :minx,
                :miny,
                :maxx,
                :maxy,
                :tag_slugs,
                :active,
                :slider_id,
                :attribution
end
