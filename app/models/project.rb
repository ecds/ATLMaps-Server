class Project < ActiveRecord::Base

  has_many :projectlayer
  has_many :layers, through: :projectlayer, dependent: :destroy
  belongs_to :user

end

