require 'test_helper'

class TagTest < ActiveSupport::TestCase
    test 'slug attibute should be parameterized' do
        tag = Tag.find(2)
        assert_equal 'oral-history', tag.slug
    end
end
