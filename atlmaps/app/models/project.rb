class Project < ActiveRecord::Base

  has_many :projectlayer
  has_many :layers, through: :projectlayer

end

