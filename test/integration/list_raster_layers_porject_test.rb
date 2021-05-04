# frozen_string_literal: true

require('test_helper')

class ListRasterLayersProjectTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  # test 'list raster layer projects' do
  #     get '/v1/raster-layer-projects.json'
  #     assert_equal 200, response.status
  #
  #     results = JSON.parse(response.body)
  #     assert_equal 4, results['raster_layer_projects'].length
  # end

  test 'showing one raster layer project relation' do
    get '/v1/raster-layer-projects/2.json'
    assert_equal 200, response.status

    results = JSON.parse(response.body)['data']['relationships']
    assert_equal '2', results['raster-layer']['data']['id']
    assert_equal '1', results['project']['data']['id']
  end

  test 'show raster layer project relation by layer id and project id' do
    get '/v1/raster-layer-projects',
        params: { raster_layer_id: 1, project_id: 1 }
    results = JSON.parse(response.body)['data']['relationships']
    assert_equal 200, response.status
    assert_equal '1', results['raster-layer']['data']['id']
    assert_equal '1', results['project']['data']['id']
  end

  test 'show raster layer project relation by project id' do
    get '/v1/raster-layer-projects', params: { project_id: 1 }
    results = JSON.parse(response.body)['data'][0]
    puts results['relationships'].length
    assert_equal 200, response.status
    #   assert_equal '1', results['relationships'][0]['project']['data']['id']
    #   assert_equal '2', results['relationships'][0]['raster-layer']['data']['id']
    #   assert_equal '1', results['relationships'][1]['project']['data']['id']
    assert_equal '2', results['relationships']['raster-layer']['data']['id']
  end
end
