class LayerSerializer < ActiveModel::Serializer
  embed :ids # this is key for the Ember data to work.
  
  has_many :projects
  
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
              :maxy,
              :projects
end
