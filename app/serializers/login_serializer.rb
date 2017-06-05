# Serializer for Logins
class LoginSerializer < ActiveModel::Serializer
    attributes :id, :identification, :email_confirmed
end
