# frozen_string_literal: true

require('test_helper')

class InstitutionTest < ActiveSupport::TestCase
  test 'slug attibute should be parameterized' do
    institution = Institution.find(1)
    assert_equal 'emory-university', institution.slug
  end
end
