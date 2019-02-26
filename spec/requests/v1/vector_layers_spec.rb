require 'rails_helper'

RSpec.describe 'V1::RasterLayers', type: :request do
    describe 'GET /vector_layers with vector_features' do
        let!(:vector_layer) { create_list(:vector_layer_with_features, 10) }
        it 'returns a vector_layer with features' do
            VectorLayer.all.each do |v|
                v.save
                expect(v.boundingbox).to be_a_kind_of(RGeo::Geographic::ProjectedPolygonImpl)
            end
        end
    end

    describe 'GET /vector_layers with vector_features with youtube urls' do
        let!(:feature) { create(:vector_feature, with_youtube: true, vector_layer: create(:vector_layer)) }
        it 'returns a vector_feature with a youtube video in properties' do
            expect(feature.youtube).to start_with('http://youtube.com')
        end
    end

    describe 'GET /vector_layers with vector_features with youtube in gx_media_links' do
        let!(:feature) { create(:vector_feature, with_gx_media_links: true, vector_layer: create(:vector_layer)) }
        it 'returns a vector_feature with a youtube video in properties' do
            expect(feature.youtube).to start_with('http://youtube.com')
        end
    end

    describe 'GET /vector_layers with text search' do
        fixtures :vector_layers, :vector_features
        context 'feature properties includes the the words Antioch East Baptist Church'
        before { get '/vector-layers?search=true&text_search=Antioch East Baptist Church' }
        it 'returns raster layers near auburn and hill' do
            expect(json).not_to be_empty
            expect(json.size).to eq(2)
            expect([json[0]['id'], json[1]['id']]).to include('4', '5')
        end
    end
end
