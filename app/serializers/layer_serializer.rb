# Base serializer for vector and raster layers.
class LayerSerializer < ActiveModel::Serializer
    belongs_to :institution

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
                :tag_ids,
                :project_ids,
                :slider_id
end
