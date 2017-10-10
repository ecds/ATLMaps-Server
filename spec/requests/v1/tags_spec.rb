# The colors match the boxes shown in this Codepen: https://codepen.io/jayvarner/pen/NvmWaR
require 'rails_helper'

RSpec.describe 'V1::RasterLayers', type: :request do
    let!(:category) { create(:with_tags) }
    let!(:tag_a) { category.tags.first }
    let!(:tag_b) { category.tags.last }
    let!(:raster_layer) { create(:raster_layer, active: true) }

    describe 'GET list of tags by category' do
        before { get '/categories' }
        it 'returns a category and its tags' do
            expect(response).to have_http_status(200)
            expect(json).not_to be_empty
            expect(json.size).to eq(1)
            expect(category.tags.length).to eq(5)
            expect(json.first['relationships']['tags']['data'].length).to eq(5)
        end
    end

    describe 'GET tagged layers' do
        before { raster_layer.tag_list.add(tag_a.name) }
        before { raster_layer.save }
        context 'get raster layer by tag' do
            before { get "/raster-layers?search=true&tags=#{tag_a.name}" }
            it 'returns tagged raster layers' do
                expect(response).to have_http_status(200)
                expect(json).not_to be_empty
                expect(json.size).to eq(1)
            end
        end
    end
end
