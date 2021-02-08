# frozen_string_literal: true

require('rails_helper')

RSpec.describe(VectorLayerProject, type: :model) do
  it 'creates a color map' do
    file = File.read(Rails.root.join('spec/fixtures/geojson.json'))
    data = JSON.parse(file)
    vl = create(:vector_layer, tmp_geojson: data)
    user = create(:user)
    project = create(:project, user: user)
    vlp = create(
      :vector_layer_project,
      vector_layer: vl,
      project: project,
      property: 'ACRES',
      steps: 6,
      brewer_scheme: 'RdBu',
      brewer_group: 'diverging'
    )
    cb_scheme = ColorBrewer.new.brew[vlp.brewer_scheme.to_sym]
    expect(vlp.color_map).to(be_instance_of(Array))
    expect(vlp.color_map.count).to(eq(vlp.steps))
    expect(vlp.color_map.first['color']).to(eq(cb_scheme[5]))
    expect(vlp.color_map.last['color']).to(eq(cb_scheme[-1]))
    expect(vlp.color_map.first['bottom']).to(eq(0.0))
    expect(vlp.color_map.first['top']).to(eq(170.2333))
    expect(vlp.color_map.last['bottom']).to(eq(851.6667))
    expect(vlp.color_map.last['top']).to(eq(1022.0))
  end
end
