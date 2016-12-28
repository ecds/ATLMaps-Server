require 'test_helper'
# test listing projects
class ListingProjectsTest < ActionDispatch::IntegrationTest
    setup { host! 'api.example.com' }

    # A GET request to the `projects` should only return published projects
    test 'returns published projects' do
        get '/v1/projects.json'
        assert_equal 200, response.status

        projects = JSON.parse(response.body)

        states = projects['projects'].collect { |project| project['published'] }
        refute_includes states, false

        names = projects['projects'].collect { |project| project['name'] }
        assert_includes names, '1928 Atlas'
        refute_includes names, 'Neat Project'

        assert_equal 3, projects['projects'].length
    end
    #
    # A GET request to to `projects` that should onl return featured projects
    test 'returns featured projects' do
        get '/v1/projects.json?featured=true'
        assert_equal 200, response.status
        projects = JSON.parse(response.body)
        assert_equal 3, projects['projects'].length
    end
    #
    # # When a user is authenticated the `is_mine` and `may_edit` attributes are set
    # # based on ownership or status as a collaborator.
    # test 'authenticated call to projects' do
    #     get '/v1/projects.json', headers: { Authorization: 'Bearer a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'}
    #     assert_equal 200, response.status
    #
    #     projects = JSON.parse(response.body)
    #
    #     p_one = projects['projects'][0]
    #     p_two = projects['projects'][1]
    #     p_three = projects['projects'][2]
    #
    #
    #     assert p_two['is_mine']
    #     assert p_two['may_edit']
    #     assert p_one['may_edit']
    #     refute p_one['is_mine']
    #     refute p_three['is_mine']
    #     refute p_three['may_edit']
    # end

    test 'get projects by user id' do
        get '/v1/projects.json?user_id=1', params: { user_id: 1 }, headers: { Authorization: 'Bearer a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf' }
        assert_equal 200, response.status
        assert_equal 2, JSON.parse(response.body)['projects'].length
    end

    test 'get project by name' do
        get '/v1/projects.json?name=One%20Last%20Project'
        assert_equal 200, response.status
        assert_equal 5, JSON.parse(response.body)['project']['id']
    end

    # test 'get list of collaborative projects for a user' do
    #     get '/v1/projects.json?collaborations=1', params: { collaborations: 1 }, headers: { Authorization: 'a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'}
    #
    #     assert_equal 200, response.status
    #     assert_equal 2, JSON.parse(response.body)['projects'].length
    # end
end
