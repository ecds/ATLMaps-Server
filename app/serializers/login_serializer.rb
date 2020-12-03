# frozen_string_literal: true

# Serializer for Logins
class LoginSerializer < ActiveModel::Serializer
  attributes :id, :token
end
