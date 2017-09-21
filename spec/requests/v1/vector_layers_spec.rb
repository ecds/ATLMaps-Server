require 'rails_helper'

RSpec.describe 'V1::RasterLayers', type: :request do
    fixtures :vector_layers, :vector_features
    describe 'GET /vector_layers with text search' do
        context 'feature properties includes the the words Antioch East Baptist Church'
        before { get '/vector-layers?search=true&text_search=Antioch East Baptist Church' }
        it 'returns raster layers near auburn and hill' do
            expect(json).not_to be_empty
            expect(json.size).to eq(2)
            expect([json[0]['id'], json[1]['id']]).to include('4', '5')
        end
    end
end
