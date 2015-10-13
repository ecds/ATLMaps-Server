module ActiveModel::SerializerSupport
  extend ActiveSupport::Concern
end

class Search
  include ActiveModel::Serialization
  include ActiveModel::SerializerSupport

  attr_accessor :layers, :vectors

  def initialize(layers, vectors)
    @layers, @vectors = layers, vectors
  end
end