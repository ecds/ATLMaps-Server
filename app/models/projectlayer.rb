class Projectlayer < ActiveRecord::Base
  belongs_to :project

  default_scope {order("position DESC") }
end
