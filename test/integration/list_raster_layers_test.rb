require 'test_helper'

class ListRasterLayersTest < ActionDispatch::IntegrationTest

  setup { host! 'api.example.com' }

  # A GET request for all raster layers
  test 'returns a single published project unauthenticated' do
    get '/v1/rasterLayers.json'
    assert_equal 200, response.status

    layers = JSON.parse(response.body)

    states = layers['raster_layers'].collect { |layer| layer['active'] }
    refute_includes states, false

    in_project = layers['raster_layers'].collect { |layer| layer['active_in_project'] }
    refute_includes in_project, true

    # Only two are returned because one is not active
    assert_equal layers['raster_layers'].length, 2

  end

  # A GET request for a all raster layers from within a project
  test 'some layers should be active in project' do
    get '/v1/rasterLayers.json?projectID=1'
    assert_equal 200, response.status

    layers = JSON.parse(response.body)

    l_one = layers['raster_layers'][0]
    l_two = layers['raster_layers'][1]

    assert l_one['active_in_project']
    refute l_two['active_in_project']

  end

end
