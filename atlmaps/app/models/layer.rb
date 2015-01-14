class Layer < ActiveRecord::Base

  has_many :projectlayer
  has_many :projects, through: :projectlayer
  belongs_to :institution
  
  has_and_belongs_to_many :tags

end
