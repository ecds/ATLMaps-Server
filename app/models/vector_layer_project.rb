class VectorLayerProject < ActiveRecord::Base
    belongs_to :vector_layer
    belongs_to :project

    # FIXME: WTF?
    def data_type
        return ''
    end
end
