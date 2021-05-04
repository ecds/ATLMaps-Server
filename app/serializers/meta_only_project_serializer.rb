# frozen_string_literal: true

# app/serializers/meta_only_project_serializer.rb
class MetaOnlyProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :photo
end
