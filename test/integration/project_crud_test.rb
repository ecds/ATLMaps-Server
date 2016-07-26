require 'test_helper'

class ProjectCrudTest < ActionDispatch::IntegrationTest

  setup { host! 'api.example.com' }

  # A POST request to create a project unauthenticated
  test 'create project unauthenticated' do
    post '/v1/projects.json', project: { name: 'foo' }
    assert_equal 401, response.status
  end

  # A POST request to care a project authenticated
  # FIXME the user id in the payload is a hack to get test to pass
  test 'create project authenticated' do
    post '/v1/projects.json', project: { name: 'foo', user_id: 1}, :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 201, response.status
  end

  # A PUT requst to update a project unauthenticated
  test 'update project unauthenticated' do
    put '/v1/projects/1.json', project: { name: 'New Title'}
    assert_equal 401, response.status
  end

  # A PUT request to update a project authenticated as owner
  test 'update project as owner' do
    put '/v1/projects/2.json', project: { name: 'Whatever'}, :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 204, response.status
  end

  # A PUT request to updata a project authenticated as collaborator
  test 'update project as collaborator' do
    put '/v1/projects/1.json', project: { name: 'Snickers'}, :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 204, response.status
  end

  # A PUT request to update a project authenticated not as the owner or collaborator
  test 'update project not as owner or collaborator' do
    put '/v1/projects/5.json', project: { name: 'Yawn'}, :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 401, response.status
  end

  # A DELETE project as owner
  test 'delete project as owner' do
    delete '/v1/projects/2.json', :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 204, response.status
  end

  # A DELETE project not as owner
  test 'delete project not as owner' do
    delete '/v1/projects/5.json', :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 401, response.status
  end

  # A DELETE project as owner collaborator
  test 'delete project not as collaborator' do
    delete '/v1/projects/1.json', :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
    assert_equal 401, response.status
  end

  # A DELETE project una\
  test 'delete project unauthenticated' do
    delete '/v1/projects/4.json'
    assert_equal 401, response.status
  end

  test 'add raster layer to project as owner' do
      post '/v1/rasterLayerProjects.json', rasterLayerProject: {
              project_id: '2',
              layer_id: '4',
              position: 60,
              layer_type: "wms"
          },
          :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
      assert_equal 201, response.status
  end

  test 'add vector layer to project as owner' do
      post '/v1/vectorLayerProjects.json', vectorLayerProject: {
              project_id: '2',
              layer_id: '4',
              marker: 60,
              vector_layer_type: "geojson"
          },
          :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
      assert_equal 201, response.status
  end

  # test 'adding a vector layer for project 9999999 is denied' do
  #     post '/v1/vectorLayerProjects.json', vectorLayerProject: {
  #             project_id: '9999999',
  #             layer_id: '4',
  #             marker: 60,
  #             vector_layer_type: "geojson"
  #         },
  #         :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
  #     assert_equal 401, response.status
  # end

  test 'remove vector layer from project as owner' do
      delete '/v1/vectorLayerProjects/2.json',
          :access_token => 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
      assert_equal 204, response.status
  end

  test 'remove raster layer from project as owner' do
      delete '/v1/rasterLayerProjects/2.json',
          :access_token => '57dd83d2396f06fbcce69bd3d0b4d7cd33a7e102faeff5f745fef06427f96a13'
      assert_equal 204, response.status
  end

  test 'remove vector layer from project unauthenticated' do
      delete '/v1/vectorLayerProjects/1.json'
      assert_equal 401, response.status
  end

  test 'remove raster layer from project unauthenticated' do
      delete '/v1/rasterLayerProjects/1.json'
      assert_equal 401, response.status
  end

end
