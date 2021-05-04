# frozen_string_literal: true

require('test_helper')

class ListRasterLayersTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  # A GET request for all raster layers
  test 'returns a list of raster layers' do
    get '/v1/raster-layers.json'
    assert_equal 200, response.status

    layers = JSON.parse(response.body)

    states = layers['raster_layers'].collect { |layer| layer['active'] }
    assert_not_includes states, false

    in_project = layers['raster_layers'].collect { |layer| layer['active_in_project'] }
    assert_not_includes in_project, true

    # Only two are returned because one is not active
    assert_equal 4, layers['raster_layers'].length

    assert_equal 'Atlanta Airport 1967', layers['raster_layers'][0]['title']
  end

  # This is now handeled by the client.

  # # A GET request for a all raster layers from within a project
  # test 'some layers should be active in project' do
  #   get '/v1/raster-layers.json?projectID=1'
  #   assert_equal 200, response.status
  #
  #   layers = JSON.parse(response.body)
  #
  #   l_one = layers['raster_layers'][0]
  #   l_two = layers['raster_layers'][1]
  #
  #   assert l_one['active_in_project']
  #   refute l_two['active_in_project']

  # end

  test 'view raster layer' do
    get '/v1/rasterLayers/2.json'
    assert_equal 200, response.status
    layer = JSON.parse(response.body)
    assert_equal 1, layer.length
    assert_equal "Bird's eye view", layer['raster_layer']['title']
    assert_equal 'atl1871-2', layer['raster_layer']['slug']
  end
end
