require 'rails_helper'

RSpec.describe 'API::V1::RasterLayers', type: :request do
    describe 'GET /raster_layers' do
        fixtures :institutions, :raster_layers
        before(:each) do
            host! 'api.example.com'
        end
        before { get '/v1/raster-layers?search=true&bounds%5Bs%5D=33.7430410068185&bounds%5Bn%5D=33.75406717933589&bounds%5Be%5D=-84.33897256851196&bounds%5Bw%5D=-84.36540842056276' }

        it 'returns raster layers' do
            expect(json).not_to be_empty
            expect(json.size).to eq(9)
        end

        # orange
        # green
        # darkblue
        # red
        # brown
        # black
        # yellow
        # purple
        # lime
    end
end
