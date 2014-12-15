class LayerSerializer < ActiveModel::Serializer
  #embed :ids # this is key for the Ember data to work.
  
  #has_many :projectlayers
  
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
              :institution
end
