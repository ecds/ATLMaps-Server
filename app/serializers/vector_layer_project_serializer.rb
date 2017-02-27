class VectorLayerProjectSerializer < ActiveModel::Serializer
    # has_one :vector_layer => :data_type
    attributes :id, :project_id, :vector_layer_id, :marker, :data_format, :data_type

    # def data_type
    #     return :vector_layer[:data_type]
    # end
end
