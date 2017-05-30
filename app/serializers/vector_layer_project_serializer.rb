class VectorLayerProjectSerializer < ActiveModel::Serializer
    belongs_to :vector_layer, serializer: VectorLayerSerializer
    belongs_to :project
    attributes :id, :marker, :data_format, :data_type

    # def data_type
    #     return :vector_layer[:data_type]
    # end
end
