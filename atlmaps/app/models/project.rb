class Project < ActiveRecord::Base

  has_and_belongs_to_many :layers
  #belongs_to :user

end
