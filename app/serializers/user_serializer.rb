class UserSerializer < ActiveModel::Serializer
  
  has_many :projects, embed: :ids
  
  attributes :id, :email, :displayname, :avatar
end
