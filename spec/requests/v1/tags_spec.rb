# The colors match the boxes shown in this Codepen: https://codepen.io/jayvarner/pen/NvmWaR
require 'rails_helper'

RSpec.describe 'V1::RasterLayers', type: :request do
    let!(:category) { create(:with_tags) }
    let!(:tag_a) { category.tags.first }
    let!(:tag_b) { category.tags.last }
    let!(:raster_layer) { create(:raster_with_tags) }

    # context 'GET list of tags by category' do
    #     before { get '/categories' }
    #     it 'returns a category and its tags' do
    #         expect(response).to have_http_status(200)
    #         expect(json).not_to be_empty
    #         expect(json.size).to eq(1)
    #         expect(category.tags.length).to eq(5)
    #         expect(json.first['relationships']['tags']['data'].length).to eq(5)
    #     end
    # end

    # context 'GET tagged layers' do    
    #     # let!(:raster) { create(:raster_layer_with_tags, active: true) }
    #     # before { raster_layer.tag_list.add(Tag.last.name) }
    #     # before { raster_layer.save }
    #     before { get "/raster-layers.json" }
    #     it 'returns tagged raster layers' do
    #         # puts response.parsed_body
    #         puts RasterLayer.last.tag_list
    #         expect(response).to have_http_status(200)
    #         expect(json).not_to be_empty
    #         expect(json.size).to eq(1)
    #     end
    # end
end
