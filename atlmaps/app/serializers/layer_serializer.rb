class LayerSerializer < ActiveModel::Serializer
  #embed :ids # this is key for the Ember data to work.
  
  has_many :projects, embed: :ids
  has_many :tags, embed: :ids
  has_one :institution
  
  attributes  :id,
              :name,
              :slug,
              :keywords,
              :description,
              :url,
              :layer,
              :date,
              :layer_type,
              :minzoom,
              :maxzoom,
              :minx,
              :miny,
              :maxx,
              :maxy,
              #:institution,
              :tag_slugs,
              :institution_slug
end
