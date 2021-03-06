# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  # ActiveModel::Serializer.config.adapter = :json

  has_many :tags

  attributes :id, :name, :slug
end
