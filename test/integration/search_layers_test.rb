require 'test_helper'

class SearchLayersTest < ActionDispatch::IntegrationTest
    setup { host! 'api.example.com' }

    # A POST request to create a project unauthenticated
    # test 'search by tags' do
    #   get '/v1/searches.json', { tags: ['Stadiumville', 'Oral History'] }
    #   assert_equal 200, response.status
    #   results = JSON.parse(response.body)
    #   assert_equal nil, results['searches']['raster_layer_ids']
    #   assert_equal nil, results['searches']['vector_layer_ids']
    #
    #   get '/v1/searches.json', { tags: ['History', 'Turner Field']}
    #   assert_equal 200, response.status
    #   results = JSON.parse(response.body)
    #   assert_equal 1, results['searches']['raster_layer_ids'].length
    #   assert_equal 2, results['searches']['vector_layer_ids'].length
    # end
    #
    # test 'search by year range' do
    #     get '/v1/searches.json', {start_year: 1922, end_year: 1992}
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal 1, results['searches']['raster_layer_ids'].length
    #     assert_equal 2, results['searches']['vector_layer_ids'].length
    #
    #     get '/v1/searches.json', {start_year: 2022, end_year: 2080}
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal nil, results['searches']['raster_layer_ids']
    #     assert_equal nil, results['searches']['vector_layer_ids']
    # end
    #
    # test 'search by institution' do
    #     get '/v1/searches.json', { name: 'Emory University'}
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal 2, results['searches']['raster_layer_ids'].length
    #     assert_equal 1, results['searches']['vector_layer_ids'].length
    #
    #     get '/v1/searches.json', { name: 'Georgia State University'}
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal 1, results['searches']['raster_layer_ids'].length
    #     assert_equal 1, results['searches']['vector_layer_ids'].length
    #
    #     get '/v1/searches.json', { name: 'Kennesaw State University'}
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal nil, results['searches']['raster_layer_ids']
    #     assert_equal nil, results['searches']['vector_layer_ids']
    # end
    #
    # test 'text search' do
    #     get '/v1/searches.json', {text_search: 'hello', tags: ''}
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal 2, results['searches']['raster_layer_ids'].length
    #     assert_equal 1, results['searches']['vector_layer_ids'].length
    # end
    #
    # test 'all filters' do
    #     get '/v1/searches.json', {
    #         tags: ['History', 'Turner Field'],
    #         name: 'Emory University',
    #         start_year: 1922,
    #         end_year: 1999,
    #         text_search: 'streets'
    #     }
    #     results = JSON.parse(response.body)
    #     puts results
    #     puts '!!!!!!!'
    #     assert_equal 1, results['searches']['raster_layer_ids'].length
    #     assert_equal 1, results['searches']['vector_layer_ids'].length
    # end
    #
    # test 'return empty arrays' do
    #     get '/v1/searches.json'
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal nil, results['searches']['raster_layer_ids']
    #     assert_equal nil, results['searches']['vector_layer_ids']
    #
    #     get '/v1/searches.json?end_year=&start_year=&text_search='
    #     assert_equal 200, response.status
    #     results = JSON.parse(response.body)
    #     assert_equal nil, results['searches']['raster_layer_ids']
    #     assert_equal nil, results['searches']['vector_layer_ids']
    # end
end
