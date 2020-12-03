# frozen_string_literal: true

# spec/models/vector_layer_spec.rb
require('rails_helper')

# Test suite for the Item model
RSpec.describe(VectorLayer, type: :model) do
  it { should have_many(:vector_layer_project) }
end
