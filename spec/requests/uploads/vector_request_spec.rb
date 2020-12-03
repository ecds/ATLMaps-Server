# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Upload::Vectors', type: :request) do
  geojson_path = Rails.root.join('spec/fixtures/geojson.json')
  shapefile_path = Rails.root.join('spec/fixtures/shpefile.zip')
  let!(:geojson) { fixture_file_upload(geojson_path) }
  let!(:shapefile) { fixture_file_upload(shapefile_path) }

  context 'POST /uploads/vector/parse with geojson' do
    before { post '/uploads/vector/parse', params: { fileToParse: geojson } }
    it 'returns a list of attributes' do
      expect(response).to(have_http_status(200))
    end
  end
end
