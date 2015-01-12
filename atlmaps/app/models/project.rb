class Project < ActiveRecord::Base

  has_many :projectlayer
  has_many :layers, through: :projectlayer
  belongs_to :user

end

