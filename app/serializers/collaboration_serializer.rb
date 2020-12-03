# frozen_string_literal: true

class CollaborationSerializer < ActiveModel::Serializer
  # has_many :user
  attributes :id, :user_id, :project_id, :user
end
