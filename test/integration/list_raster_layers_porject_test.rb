require 'test_helper'

class ListRasterLayersProjectTest < ActionDispatch::IntegrationTest

  setup { host! 'api.example.com' }

  test 'list raster layer projects' do
      get '/v1/rasterLayerProjects.json'
      assert_equal 200, response.status

      results = JSON.parse(response.body)
      assert_equal 4, results['raster_layer_projects'].length
  end

  test 'showing one raster layer project relation' do
      get '/v1/rasterLayerProjects/2.json'
      assert_equal 200, response.status

      results = JSON.parse(response.body)
      assert_equal 1, results['raster_layer_project']['project_id']
      assert_equal 2, results['raster_layer_project']['raster_layer_id']
  end

  test 'show raster layer project relation by layer id and project id' do
      get '/v1/rasterLayerProjects', {raster_layer_id: 1, project_id: 1}
      results = JSON.parse(response.body)
      assert_equal 200, response.status
      assert_equal 1, results['raster_layer_projects'][0]['project_id']
      assert_equal 1, results['raster_layer_projects'][0]['raster_layer_id']
  end

end
