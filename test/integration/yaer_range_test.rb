require 'test_helper'

class YearRangeTest < ActionDispatch::IntegrationTest

  setup { host! 'api.example.com' }

  test 'returns the max and min years in RasterLayer and VectorLayer' do
    get '/v1/yearRanges/1.json'
    assert_equal 200, response.status

    year_range = JSON.parse(response.body)
    assert_equal 1944, year_range['year_range']['min_year']
    assert_equal 2000, year_range['year_range']['max_year']
    assert_equal 1, year_range['year_range']['id']
  end

end
