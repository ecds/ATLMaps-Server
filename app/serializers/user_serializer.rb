# Serializer class for users.
class UserSerializer < ActiveModel::Serializer
    has_many :projects, embed: :ids
    # has_many :projects
    has_many :collaboration
    has_one :institution

    attributes :id, :displayname, :confirmed
end
