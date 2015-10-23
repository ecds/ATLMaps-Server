class CategorySerializer < ActiveModel::Serializer
  has_many :tags, embed: :ids

  attributes  :id, :name, :tag_ids
end
