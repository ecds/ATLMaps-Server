# Serializer for Logins
class LoginSerializer < ActiveModel::Serializer
    attributes :id, :identification, :confirmed
end