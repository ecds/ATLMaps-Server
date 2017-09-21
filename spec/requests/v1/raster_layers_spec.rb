# The colors match the boxes shown in this Codepen: https://codepen.io/jayvarner/pen/NvmWaR
require 'rails_helper'

RSpec.describe 'V1::RasterLayers', type: :request do
    fixtures :institutions, :raster_layers
    describe 'GET /raster_layers near auburn and hill - green box' do
        context 'focused on auburn and hill' do
            before { get '/raster-layers?search=true&bounds%5Bs%5D=33.75323758946669&bounds%5Bn%5D=33.757902813079326&bounds%5Be%5D=-84.37154531478883&bounds%5Bw%5D=-84.38896894454957' }
            it 'returns raster layers near auburn and hill' do
                expect(json).not_to be_empty
                expect(json.size).to eq(7)
                expect(json[0]['attributes']['name']).to eq('lightblue')
                expect(json[1]['attributes']['name']).to eq('purple')
                expect(json[2]['attributes']['name']).to eq('deeppink')
                expect(json[3]['attributes']['name']).to eq('wheat')
                expect(json[4]['attributes']['name']).to eq('black')
                expect(json[5]['attributes']['name']).to eq('yellow')
                expect(json[6]['attributes']['name']).to eq('lime')
            end
        end
    end

    describe 'GET /raster_layers near reynoldstown' do
        context 'focused on reynoldstown - deeppink box' do
            before { get '/raster-layers?search=true&bounds%5Bs%5D=33.7430410068185&bounds%5Bn%5D=33.75406717933589&bounds%5Be%5D=-84.33897256851196&bounds%5Bw%5D=-84.36540842056276' }
            it 'returns raster layers in reynoldstown' do
                expect(json).not_to be_empty
                expect(json.size).to eq(9)
                expect(json[0]['attributes']['name']).to eq('orange')
                expect(json[1]['attributes']['name']).to eq('green')
                expect(json[2]['attributes']['name']).to eq('darkblue')
                expect(json[3]['attributes']['name']).to eq('red')
                expect(json[4]['attributes']['name']).to eq('brown')
                expect(json[5]['attributes']['name']).to eq('black')
                expect(json[6]['attributes']['name']).to eq('yellow')
                expect(json[7]['attributes']['name']).to eq('purple')
                expect(json[8]['attributes']['name']).to eq('lime')
            end
        end
    end

    describe 'GET /raster_layers match lime' do
        context 'zoomed out to include all layers' do
            before { get '/raster-layers?search=true&bounds%5Bs%5D=34.07936423&bounds%5Bn%5D=33.50058196&bounds%5Be%5D=-84.06082848&bounds%5Bw%5D=-84.62628431&limit=17' }
            it 'returns raster layers within the lime bounds' do
                expect(json).not_to be_empty
                expect(json.size).to eq(17)
                expect(json[0]['attributes']['name']).to eq('lime')
                expect(json[1]['attributes']['name']).to eq('gold')
                expect(json[2]['attributes']['name']).to eq('yellow')
                expect(json[3]['attributes']['name']).to eq('black')
                expect(json[4]['attributes']['name']).to eq('red')
                expect(json[5]['attributes']['name']).to eq('darkblue')
                expect(json[6]['attributes']['name']).to eq('orange')
                expect(json[7]['attributes']['name']).to eq('green')
                expect(json[8]['attributes']['name']).to eq('purple')
                expect(json[9]['attributes']['name']).to eq('lightblue')
                expect(json[10]['attributes']['name']).to eq('deeppink')
                expect(json[11]['attributes']['name']).to eq('brown')
                expect(json[12]['attributes']['name']).to eq('wheat')
                expect(json[13]['attributes']['name']).to eq('pink')
                expect(json[14]['attributes']['name']).to eq('grey')
                expect(json[15]['attributes']['name']).to eq('darkred')
                expect(json[16]['attributes']['name']).to eq('darkviolet')
            end
        end
    end

    describe 'GET /raster_layers around emory' do
        context 'focused on emory' do
            before { get '/raster-layers?search=true&bounds%5Bs%5D=33.78298184257755&bounds%5Bn%5D=33.80061838317273&bounds%5Be%5D=-84.30071353912355&bounds%5Bw%5D=-84.34184789657594' }
            it 'returns raster layers within the lime bounds' do
                expect(json).not_to be_empty
                expect(json.size).to eq(4)
                expect(json[0]['attributes']['name']).to eq('gold')
                expect(json[1]['attributes']['name']).to eq('yellow')
                expect(json[2]['attributes']['name']).to eq('darkred')
                expect(json[3]['attributes']['name']).to eq('lime')
            end
        end
    end
end
