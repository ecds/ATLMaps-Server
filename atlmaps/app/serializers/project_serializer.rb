class ProjectSerializer < ActiveModel::Serializer
  embed :ids # this is key for the Ember data to work.
  
  has_many :layers
  #premit :layers
  
  attributes  :id,
              :name,
              :description,
              :status,
              :layers

end
