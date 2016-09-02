class RasterLayerSerializer < LayerSerializer

  #embed :ids # this is key for the Ember data to work.

  # has_many :projects, embed: :ids
  # has_many :tags, embed: :ids
  #has_many :projectlayer
  # has_one :institution
  # belongs_to :raster_layer_project
  attributes  :slider_id,
              # :tag_ids,
              :workspace,
              :layers


end
