# frozen_string_literal: true

# spec/models/vector_layer_spec.rb
require('rails_helper')

# Test suite for the Item model
RSpec.describe(VectorLayer, type: :model) do
  it 'creates a vector layer and color map' do
    file = File.read(Rails.root.join('spec/fixtures/geojson.json'))
    data = JSON.parse(file)
    vl = create(:vector_layer, tmp_geojson: data, default_break_property: 'ACRES')
    expect(vl.color_map).to(be_instance_of(Array))
    expect(vl.color_map.count).to(eq(5))
    expect(vl.color_map.first['bottom']).to(eq(0.0))
    expect(vl.color_map.first['top']).to(eq(204.3))
    expect(vl.color_map.first['color']).not_to(be(nil))
    expect(vl.color_map.last['bottom']).to(eq(817.6))
    expect(vl.color_map.last['top']).to(eq(1022.0))
    expect(vl.color_map.last['color']).not_to(be(nil))
  end

  it 'creates a vector layer and color map when range is less than steps' do
    file = File.read(Rails.root.join('spec/fixtures/2018NSA.json'))
    data = JSON.parse(file)
    vl = create(:vector_layer, tmp_geojson: data, default_break_property: 'Percent NH American Indian and Alaska Native Population')
    expect(vl.color_map).to(be_instance_of(Array))
    expect(vl.color_map.count).to(eq(5))
    expect(vl.color_map.first['bottom']).to(eq(0.0))
    expect(vl.color_map.first['top']).to(eq(0.3))
    expect(vl.color_map.first['color']).not_to(be(nil))
    expect(vl.color_map.last['bottom']).to(eq(1.6))
    expect(vl.color_map.last['top']).to(eq(2.0))
    expect(vl.color_map.last['color']).not_to(be(nil))
  end

  it 'creates a vector layer and color map with regular steps' do
    file = File.read(Rails.root.join('spec/fixtures/simple_data.json'))
    data = JSON.parse(file)
    vl = create(:vector_layer, tmp_geojson: data, default_break_property: 'prop1')
    expect(vl.color_map).to(be_instance_of(Array))
    expect(vl.color_map.count).to(eq(5))
    expect(vl.color_map.first['bottom']).to(eq(5.0))
    expect(vl.color_map.first['top']).to(eq(24.9))
    expect(vl.color_map.first['color']).not_to(be(nil))
    expect(vl.color_map.last['bottom']).to(eq(85.0))
    expect(vl.color_map.last['top']).to(eq(100.0))
    expect(vl.color_map.last['color']).not_to(be(nil))
  end

  it 'corrects invalid GeoJSON on validataion' do
    file = File.read(Rails.root.join('spec/fixtures/invalid.json'))
    no_features = RGeo::GeoJSON.decode(file)
    expect(no_features.count).to(be_zero)
    data = JSON.parse(file, symbolize_names: true)
    expect(data[:features].first[:type]).not_to(eq('Feature'))
    vl = build(:vector_layer, tmp_geojson: data)
    expect(vl.tmp_geojson[:features].first[:type]).not_to(eq('Feature'))
    expect(vl.tmp_geojson[:features].first).not_to(have_key('geometry'))
    expect(vl.tmp_geojson[:features].first).to(have_key('geometries'))
    vl.validate!
    expect(vl.tmp_geojson[:features].first[:type]).to(eq('Feature'))
    expect(vl.tmp_geojson[:features].first).to(have_key('geometry'))
    expect(vl.tmp_geojson[:features].first[:geometry][:type]).to(eq('GeometryCollection'))
    expect(vl.tmp_geojson[:features].first).not_to(have_key('geometries'))
    expect(vl.tmp_geojson[:features].first[:geometry][:geometries].first[:coordinates]).to(
      eq(data[:features].first[:geometries].first[:coordinates])
    )
    features = RGeo::GeoJSON.decode(JSON.dump(vl.tmp_geojson))
    expect(features.count).not_to(be_zero)
  end
end
