# Serializer to expose attributes for Vector Features.
class VectorFeatureSerializer < ActiveModel::Serializer
    attributes :id,
               :geometry_type,
               :properties,
               :geojson,
               :layer_title,
               :name,
               :description,
               :images,
               :youtube,
               :vimeo,
               :audio
end