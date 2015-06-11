class ProjectlayerSerializer < ActiveModel::Serializer
  attributes :id, :project_id, :layer_id, :marker, :layer_type
end
