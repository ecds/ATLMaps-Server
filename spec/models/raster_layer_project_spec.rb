# frozen_string_literal: true

# spec/models/raster_layer_project_spec.rb
require('rails_helper')

# Test suite for the Item model
RSpec.describe(RasterLayerProject, type: :model) do
  # Association test
  # ensure an item record belongs to a single todo record
  it { should belong_to(:project) }
  # Validation test
  # ensure column name is present before saving
  # it { should validate_presence_of(:position) }
end
