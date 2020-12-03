# frozen_string_literal: true

# spec/models/project_spec.rb
require('rails_helper')

# Test suite for the Todo model
RSpec.describe(Project, type: :model) do
  # Association test
  # ensure Todo model has a 1:m relationship with the Item model
  it { should have_many(:raster_layer_project).dependent(:destroy) }
  # Validation tests
  # ensure columns title and created_by are present before saving
  # it { should validate_presence_of(:name) }
  # it { should validate_presence_of(:owner) }
end
