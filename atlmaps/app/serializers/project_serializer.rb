class ProjectSerializer < ActiveModel::Serializer
  embed :ids # this is key for the Ember data to work.
  
  has_many :layers
  
  attributes  :id,
              :name,
              :description,
              :status

end
