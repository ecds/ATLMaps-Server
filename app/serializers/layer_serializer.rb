class LayerSerializer < ActiveModel::Serializer

  #embed :ids # this is key for the Ember data to work.

  # has_many :projects, embed: :ids
  # has_many :tags, embed: :ids
  # has_many :projects
  has_one :institution

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
              :project_ids

end
