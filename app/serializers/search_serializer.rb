class SearchSerializer < ActiveModel::Serializer
   has_many :layers, embed: :objects
   has_many :vectors, embed: :objects
end
