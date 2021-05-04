# frozen_string_literal: true

require('rails_helper')

RSpec.describe('V1::VectorLayers', type: :request) do
  describe 'GET /vector_layers with vector_features' do
    let!(:vector_layer) { create(:vector_layer, url: 'http://points.org', data_format: 'remote') }
    it 'returns a vector_layer with features' do
      vector_layer.save!
      expect(vector_layer.boundingbox).to(be_a_kind_of(RGeo::Geos::CAPIPolygonImpl))
    end
  end

  describe 'GET /vector_layers with text search' do
    context 'feature properties includes the the words Ford Prefect'
    before do
      create(:vector_layer, url: 'http://points.org', active: true, data_format: 'remote', data_type: 'quantitative')
      create(:vector_layer, url: 'http://polygons.org', active: true, data_format: 'remote', data_type: 'quantitative')
      get '/vector-layers?search=true&text_search=Ford Prefect&type=quantitative'
    end
    it 'returns vector layers related to Ford Prefect' do
      expect(json).not_to(be_empty)
      expect(json.size).to(eq(1))
      expect(json[0]['attributes']['keywords']).to(include('Ford Prefect'))
    end
  end
end
