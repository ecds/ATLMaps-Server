class VectorLayerProject < ApplicationRecord
    belongs_to :vector_layer
    belongs_to :project

    def data_type
        return vector_layer.data_type
    end
end
