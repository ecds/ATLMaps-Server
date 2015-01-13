class Institution < ActiveRecord::Base
  has_many :layers
  has_many :users
end
