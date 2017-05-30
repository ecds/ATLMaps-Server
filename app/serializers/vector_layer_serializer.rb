class VectorLayerSerializer < LayerSerializer
  has_many :vector_feature, serializer: VectorFeatureSerializer
  attributes :id

end
