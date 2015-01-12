class ProjectSerializer < ActiveModel::Serializer
  
  has_many :layers, embed: :ids
  
  attributes :id, :user, :name, :saved, :published, :user_id
end
