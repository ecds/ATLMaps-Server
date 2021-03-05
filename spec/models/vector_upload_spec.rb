# frozen_string_literal: true

# spec/models/vector_layer_spec.rb
require('rails_helper')

# Test suite for the Item model
RSpec.describe(VectorUpload, type: :model) do
  let!(:geojson_file) do
    ActionDispatch::Http::UploadedFile.new(
      tempfile: File.new(
        "#{Rails.root}/spec/fixtures/geojson.json"
      ),
      filename: 'geojson.json'
    )
  end

  it 'creates a vector_upload_object' do
    vu = VectorUpload.new(file: geojson_file)
    expect(vu.type).to(eq('json'))
  end

  it 'raises an exeption with no file' do
    expect { VectorUpload.new }.to(raise_error(VectorUploadException))
  end
end
