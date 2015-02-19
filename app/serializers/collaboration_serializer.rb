class CollaborationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :project_id
end
