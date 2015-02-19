class ProjectSerializer < ActiveModel::Serializer
  
  has_many :layers, embed: :ids
  has_many :users, embed: :ids
  
  attributes :id, :name, :description, :saved, :published, :slug, :user_id, :user, :owner

end