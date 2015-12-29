class CategorySerializer < ActiveModel::Serializer

  ActiveModel::Serializer.config.adapter = :json
  
  has_many :tags, embed: :ids

  attributes  :id, :name, :slug, :tag_ids
end
