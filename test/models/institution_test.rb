require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase
  test "slug attibute shold be parameterized" do
    institution = Institution.find(1)
    assert_equal 'emory-university', institution.slug
  end
end
