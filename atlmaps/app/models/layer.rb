class Layer < ActiveRecord::Base

  has_many :projectlayer
  has_many :projects, through: :projectlayer

end
