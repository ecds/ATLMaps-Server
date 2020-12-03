# frozen_string_literal: true

require('rails_helper')

RSpec.describe('V1::RasterLayers', type: :request) do
  let!(:category) { create(:with_tags) }
  let!(:tag_a) { category.tags.first }
  let!(:tag_b) { category.tags.last }
  let!(:raster_layer) { create(:raster_layer) }

  context 'GET list of tags by category' do
    before do
      raster_layer.tag_list.add(tag_a)
      get '/categories'
    end
    it 'returns a category and its tags' do
      expect(response).to(have_http_status(200))
      expect(json).not_to(be_empty)
      expect(json.size).to(eq(1))
      expect(category.tags.length).to(eq(5))
      expect(json.first['relationships']['tags']['data'].length).to(eq(5))
    end
  end

  # TODO: Adding tags does not work
  # context 'GET tagged layers' do
  #   let!(:category) { create(:with_tags) }
  #   let!(:tag) { category.tags.first }
  #   let!(:raster) { create(:raster_layer, active: true) }
  #   before do
  #     begin
  #       raster_layer.tag_list.add(tag.name, parse: true)
  #       raster_layer.save!
  #     rescue TypeError => e
  #       puts(e.message)
  #     end
  #     puts raster_layer.tag_list.count
  #     puts tag.name
  #     get "/raster-layers.json?tags[]=#{tag.name}&search=true&limit=50"
  #   end
  #   it 'returns tagged raster layers' do
  #     # puts response.parsed_body
  #     expect(response).to(have_http_status(200))
  #     expect(json).not_to(be_empty)
  #     expect(json.size).to(eq(1))
  #   end
  # end
end
