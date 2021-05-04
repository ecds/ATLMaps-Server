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
      expect(response_data[:data]).to(be_instance_of(Array))
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
      expect(response_data[:data]).to(be_instance_of(Array))
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
      expect(response_data[:data]).to(be_instance_of(Array))
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
      expect(response_data[:data]).to(be_instance_of(Array))
      expect(response_data[:attributes]).to(include('Description'))
      expect(response_data[:attributes]).to(include('Location Name'))
      expect(response_data[:attributes]).to(include('Latitude'))
      expect(response_data[:attributes]).to(include('Longitude'))
    end
  end

  context 'POST /uploads/vector/preview assuming geojson original' do
    before do
      data = JSON.parse(File.read(Rails.root.join('spec/fixtures/geojson.json')), symbolize_names: true)
      data[:breakProperty] = 'ZONING'
      color_map = '{"A": {"color": "blue"},"B": {"color": "green"},"C": {"color": "yellow"},"D": {"color": "red"}}'
      tmp_data_path = Rails.root.join('spec/fixtures/tmp.json')
      File.open(Rails.root.join(tmp_data_path), 'w') do |file|
        file.write(data.to_json)
      end
      tmp_data = fixture_file_upload(tmp_data_path)
      post '/uploads/vector/preview', params: { file: tmp_data, mappedAttributes: "{ \"title\": \"DIST_1\", \"break\": \"ZONING\", \"colorMap\": #{color_map} }" }
      File.delete(tmp_data_path)
    end

    it 'returns geojson colored by qualitative property' do
      expect(response).to(have_http_status(200))
      expect(response_data).to(be_instance_of(Hash))
      expect(response_data[:features].first[:properties][:title]).to(eq('Sunset Avenue'))
      response_data[:features].each do |feature|
        case feature[:properties][:ZONING]
        when 'A'
          expect(feature[:properties][:color]).to(eq('blue'))
        when 'B'
          expect(feature[:properties][:color]).to(eq('green'))
        when 'C'
          expect(feature[:properties][:color]).to(eq('yellow'))
        when 'D'
          expect(feature[:properties][:color]).to(eq('red'))
        end
      end
    end
  end

  context 'POST /uploads/vector/preview assuming csv original' do
    before do
      post '/uploads/vector/preview',
           params: {
             file: csv,
             mappedAttributes: '{ "title": "Name", "longitude": "Longitude", "latitude": "Latitude", "break": "Size", "colorMap": { "brew": "Reds", "steps": 6 } }'
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
      expect(vector_layer.default_break_property).to(eq('Percent NH American Indian and Alaska Native Population'))
      expect(vector_layer.color_map).to(be_instance_of(Array))
      expect(vector_layer.color_map.length).to(eq(5))
    end
  end
end
