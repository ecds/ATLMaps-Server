require 'test_helper'

class ListvectorLayersTest < ActionDispatch::IntegrationTest
    setup { host! 'api.example.com' }

    # A GET request for all vector layers
    test 'returns a list of vector layers' do
        get '/v1/vectorLayers.json'
        assert_equal 200, response.status

        layers = JSON.parse(response.body)

        states = layers['vector_layers'].collect { |layer| layer['active'] }
        refute_includes states, false

        # in_project = layers['vector_layers'].collect { |layer| layer['active_in_project'] }
        # refute_includes in_project, true

        # Only two are returned because one is not active
        assert_equal 2, layers['vector_layers'].length

        assert_equal 'Mountain View / Airport Points of Interest Hello', layers['vector_layers'][0]['title']
        assert_equal 'fkeif', layers['vector_layers'][0]['name']
    end

    # A GET request for a all vector layers from within a project
    test 'some layers should be active in project' do
        get '/v1/vectorLayers.json?projectID=1'
        assert_equal 200, response.status

        # layers = JSON.parse(response.body)

        # l_one = layers['vector_layers'][0]
        # l_two = layers['vector_layers'][1]

        # assert l_one['active_in_project']
        # refute l_two['active_in_project']
    end

    test 'test search' do
        get '/v1/vectorLayers.json?query=hello'
        assert_equal 200, response.status
        results = JSON.parse(response.body)['vector_layers']
        assert_equal 2, results.length
    end

    test 'view vector layer' do
        get '/v1/vectorLayers/2.json'
        assert_equal 200, response.status
        layer = JSON.parse(response.body)
        assert_equal 1, layer.length
        assert_equal 'Historic Downtown Atlanta', layer['vector_layer']['title']
        assert_equal 'historic-downtown-atlanta-2', layer['vector_layer']['slug']
        assert_equal 'k9eke', layer['vector_layer']['name']
    end
end
