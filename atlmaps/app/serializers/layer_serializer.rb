class LayerSerializer < ActiveModel::Serializer
  embed :ids # this is key for the Ember data to work.
  
  attributes  :id,
              :name,
              :slug,
              :keywords,
              :description,
              :url,
              :layer,
              :date,
              :layer_type,
              :zoomlevels,
              :minx,
              :miny,
              :maxx,
              :maxy
end
