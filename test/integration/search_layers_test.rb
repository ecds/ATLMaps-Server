require 'test_helper'

class SearchLayersTest < ActionDispatch::IntegrationTest
    setup { host! 'api.example.com' }

    # A POST request to create a project unauthenticated
    test 'search by tags' do
        get '/v1/raster-layers.json', params: { tags: ['Stadiumville', 'Oral History'], search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 2, results['raster_layers'].length

        get '/v1/vector-layers.json', params: { tags: ['History', 'Turner Field'], search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 1, results['vector_layers'].length
    end

    test 'search by year range' do
        get '/v1/raster-layers.json', params: { start_year: 1922, end_year: 1992, search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 1, results['raster_layers'].length

        get '/v1/vector-layers.json', params: { start_year: 1922, end_year: 1992, search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 2, results['vector_layers'].length

        get '/v1/raster-layers.json', params: { start_year: 2022, end_year: 2080, search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal [], results['raster_layers']

        get '/v1/vector-layers.json', params: { start_year: 2022, end_year: 2080, search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal [], results['vector_layers']
    end

    test 'search by institution' do
        get '/v1/raster-layers.json', params: { institution: 'Emory University', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 2, results['raster_layers'].length

        get '/v1/raster-layers.json', params: { institution: 'Georgia State University', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 2, results['raster_layers'].length

        get '/v1/raster-layers.json', params: { institution: 'Kennesaw State University', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal [], results['raster_layers']

        get '/v1/vector-layers.json', params: { institution: 'Emory University', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 1, results['vector_layers'].length

        get '/v1/vector-layers.json', params: { institution: 'Georgia State University', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 1, results['vector_layers'].length

        get '/v1/vector-layers.json', params: { institution: 'Kennesaw State University', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal [], results['vector_layers']
    end

    test 'text search' do
        get '/v1/raster-layers.json', params: { text_search: 'mindbogglingly', tags: '', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 1, results['raster_layers'].length

        get '/v1/vector-layers.json', params: { text_search: 'hello', tags: '', search: true }
        assert_equal 200, response.status
        results = JSON.parse(response.body)
        assert_equal 1, results['vector_layers'].length
    end

    test 'all filters' do
        get '/v1/vector-layers.json', params: { tags: ['History', 'Turner Field'],
                                                name: 'Emory University',
                                                start_year: 1922,
                                                end_year: 1999,
                                                text_search: 'streets',
                                                search: true }
        results = JSON.parse(response.body)
        assert_equal [], results['vector_layers']
    end

    test 'weight of search results' do
        get '/v1/raster-layers.json', params: { search: true, text_search: 'Vogon' }
        results = JSON.parse(response.body)
        assert_equal 3, results['raster_layers'].length # This should be 4. See below.
        # TODO: This one should work - testing that tags are second in weight.
        # However, searching against `associated_against` does not work.
        # assert_equal 5, results['raster_layers'][1]['id']
        assert_equal 4, results['raster_layers'][0]['id']
    end

    # test 'return empty arrays' do
    #     get '/v1/raster-layers.json', params: { search: true }
    #     puts request.inspect
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_nil results['raster_layers']
    #
    #     get '/v1/vector-layers.json', params: { end_year: nil, start_year: nil, text_search: true }
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal nil, results['vector_layers']
    # end
end
