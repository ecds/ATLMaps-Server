class TagSerializer < ActiveModel::Serializer
  has_many :layers, embed: :ids
  attributes :id, :name
end
