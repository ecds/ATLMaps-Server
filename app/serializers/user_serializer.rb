class UserSerializer < ActiveModel::Serializer
  
  has_many :projects, embed: :ids
  has_one :institution
  
  attributes :id, :email, :displayname, :avatar, :projects
end
