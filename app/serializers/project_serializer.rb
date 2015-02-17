class ProjectSerializer < ActiveModel::Serializer
  
  has_many :layers, embed: :ids
  #has_one :user
  
  attributes :id, :name, :description, :saved, :published, :user_id, :user, :slug

end