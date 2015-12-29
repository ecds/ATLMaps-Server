class CollaborationSerializer < ActiveModel::Serializer

  ActiveModel::Serializer.config.adapter = :json
  
	#has_many :user
  attributes :id, :user_id, :project_id, :user
end
