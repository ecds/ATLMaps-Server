# frozen_string_literal: true

require('test_helper')

class ListVectorLayersProjectTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  # test 'list vector layer projects' do
  #     get '/v1/vectorLayerProjects.json'
  #     assert_equal 200, response.status
  #
  #     results = JSON.parse(response.body)
  #     assert_equal 4, results['vector_layer_projects'].length
  # end

  test 'showing one layer project relation' do
    get '/v1/vectorLayerProjects/2.json'
    assert_equal 200, response.status

    results = JSON.parse(response.body)
    assert_equal 2, results['vector_layer_project']['project_id']
    assert_equal 1, results['vector_layer_project']['vector_layer_id']
  end

  test 'show vector layer project relation by layer id and project id' do
    get '/v1/vectorLayerProjects',
        params: { vector_layer_id: 1, project_id: 1 }
    results = JSON.parse(response.body)
    assert_equal 200, response.status
    assert_equal 1, results['vector_layer_projects'][0]['project_id']
    assert_equal 1, results['vector_layer_projects'][0]['vector_layer_id']
  end

  test 'show vector layer project relation by project id' do
    get '/v1/vectorLayerProjects', params: { project_id: 1 }
    results = JSON.parse(response.body)
    assert_equal 200, response.status
    assert_equal 1, results['vector_layer_projects'][0]['project_id']
    assert_equal 1, results['vector_layer_projects'][0]['vector_layer_id']
  end
end
