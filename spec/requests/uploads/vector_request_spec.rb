# frozen_string_literal: true

require('rails_helper')

RSpec.describe('Upload::Vectors', type: :request) do
  fixtures :institutions
  geojson_path = Rails.root.join('spec/fixtures/geojson.json')
  shapefile_path = Rails.root.join('spec/fixtures/shpefile.zip')
  csv_path = Rails.root.join('spec/fixtures/ams.csv')
  xlsx_path = Rails.root.join('spec/fixtures/ams.xlsx')
  let!(:geojson) { fixture_file_upload(geojson_path) }
  let!(:shapefile) { fixture_file_upload(shapefile_path) }
  let!(:csv) { fixture_file_upload(csv_path) }
  let!(:xlsx) { fixture_file_upload(xlsx_path) }

  context 'POST /uploads/vector/parse with geojson' do
    before { post '/uploads/vector/parse', params: { fileToParse: geojson } }
    it 'returns a list of attributes' do
      expect(response).to(have_http_status(200))
      expect(response_data[:attributes]).to(be_instance_of(Array))
      expect(response_data[:attributes]).to(include('ACRES'))
      expect(response_data[:attributes]).to(include('ZONING'))
      expect(response_data[:attributes]).to(include('DIST_1'))
    end
  end

  context 'POST /uploads/vector/parse with shapefile' do
    before { post '/uploads/vector/parse', params: { fileToParse: shapefile } }
    it 'returns a list of attributes' do
      expect(response).to(have_http_status(200))
      expect(response_data[:attributes]).to(be_instance_of(Array))
      expect(response_data[:attributes]).to(include('ACRES'))
      expect(response_data[:attributes]).to(include('ZONING'))
      expect(response_data[:attributes]).to(include('DIST_1'))
    end
  end

  context 'POST /uploads/vector/parse with csv' do
    before { post '/uploads/vector/parse', params: { fileToParse: csv } }
    it 'returns a list of attributes' do
      expect(response).to(have_http_status(200))
      expect(response_data[:attributes]).to(be_instance_of(Array))
      expect(response_data[:attributes]).to(include('Description'))
      expect(response_data[:attributes]).to(include('Name'))
      expect(response_data[:attributes]).to(include('Latitude'))
      expect(response_data[:attributes]).to(include('Longitude'))
    end
  end

  context 'POST /uploads/vector/parse with xlsx' do
    before { post '/uploads/vector/parse', params: { fileToParse: xlsx } }
    it 'returns a list of attributes' do
      expect(response).to(have_http_status(200))
      expect(response_data[:attributes]).to(be_instance_of(Array))
      expect(response_data[:attributes]).to(include('Description'))
      expect(response_data[:attributes]).to(include('Location Name'))
      expect(response_data[:attributes]).to(include('Latitude'))
      expect(response_data[:attributes]).to(include('Longitude'))
    end
  end

  context 'POST /uploads/vector/preview assuming geojson original' do
    before { post '/uploads/vector/preview', params: { file: geojson, mappedAttributes: '{ "title": "DIST_1" }' } }
    it 'returns a list of attributes' do
      expect(response).to(have_http_status(200))
      expect(response_data).to(be_instance_of(Hash))
      expect(response_data[:features].first[:properties][:title]).to(eq('Sunset Avenue'))
    end
  end

  context 'POST /uploads/vector/preview assuming csv original' do
    before do
      post '/uploads/vector/preview',
           params: {
             file: csv,
             mappedAttributes: '{ "title": "Name", "longitude": "Longitude", "latitude": "Latitude" }'
           }
    end
    it 'returns GeoJSON with lat/lng and properties from CSV file' do
      expect(response).to(have_http_status(200))
      expect(response_data).to(be_instance_of(Hash))
      expect(response_data[:features].first[:geometry][:coordinates]).to(eq([-84.383665, 33.783723]))
      expect(response_data[:features].first[:geometry][:type]).to(eq('Point'))
      expect(response_data[:features][6][:properties][:title]).to(eq("RuPaul's second midtown apartment"))
    end
  end

  context 'POST /uploads/vector/new' do
    before do
      geojson_data = File.read('spec/fixtures/2018NSA.json')
      post '/uploads/vector/new',
           params: {
             file: geojson,
             title: 'Some Title',
             description: 'And a description',
             geojson: geojson_data
           }
    end
    it 'returs a success message' do
      expect(response).to(have_http_status(200))
      expect(response_data[:message]).to(eq('success'))
      expect(response_data[:layerTitle]).to(eq('Some Title'))
      vector_layer = VectorLayer.find(response_data[:layerId])
    end
  end
end
