class Layer < ActiveRecord::Base

  has_many :projectlayer
  has_many :projects, through: :projectlayer, dependent: :destroy
  belongs_to :institution
  
  has_and_belongs_to_many :tags, dependent: :destroy

end
