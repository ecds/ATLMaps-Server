class CategorySerializer < ActiveModel::Serializer
  has_many :tags, embed: :ids

  attributes  :id, :name, :slug, :tag_ids
end
