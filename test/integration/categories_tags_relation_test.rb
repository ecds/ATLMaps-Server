# frozen_string_literal: true

require('test_helper')

class CategoriesTagsRelationTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'returns a list of categories layers' do
    get '/v1/categories.json'
    assert_equal 200, response.status

    categories = JSON.parse(response.body)

    assert_equal categories['categories'].length, 3

    assert_equal categories['categories'][0]['tag_ids'].length, 3
  end

  test 'returns list of single category' do
    get '/v1/categories/2.json'
    assert_equal 200, response.status

    category = JSON.parse(response.body)
    assert_equal category['category']['tag_ids'].length, 2
  end
end
