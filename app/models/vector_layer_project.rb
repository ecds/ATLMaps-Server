class VectorLayerProject < ActiveRecord::Base
  belongs_to :vector_layer
  belongs_to :project

  default_scope {order("position DESC") }
end

