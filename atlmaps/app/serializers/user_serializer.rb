class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :displayname, :avatar
end
