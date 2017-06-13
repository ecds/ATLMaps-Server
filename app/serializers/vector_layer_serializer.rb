# app/serializers/vector_layer_serializer.rb
class VectorLayerSerializer < LayerSerializer
    has_many :vector_feature, serializer: VectorFeatureSerializer
    attributes :id, :filters
end
