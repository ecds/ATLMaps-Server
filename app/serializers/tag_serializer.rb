class TagSerializer < ActiveModel::Serializer

  has_many :vector_layers, embed: :ids
  has_many :categories, embed: :ids
  attributes :id, :name, :slug, :vector_layer_ids, :category_ids
end
