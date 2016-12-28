require 'test_helper'

class ViewProjectTest < ActionDispatch::IntegrationTest
    setup { host! 'api.example.com' }

    # A GET request for a single published project
    test 'returns a single published project unauthenticated' do
        get '/v1/projects/1.json'
        puts response.body
        assert_equal 200, response.status
    end

    # A GET request for a single unpublished project from a collaborator
    test 'returns 200 for unpublished project collaborator' do
        get '/v1/projects/4.json',
            headers: {
                Authorization: 'Bearer a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
            }
        assert_equal 200, response.status
    end

    # A GET request for a single unpublished project from owner
    test 'return 200 for unpublished from owner' do
        get '/v1/projects/4.json',
            headers: {
                Authorization: 'Bearer 57dd83d2396f06fbcce69bd3d0b4d7cd33a7e102faeff5f745fef06427f96a13'
            }
        assert_equal 200, response.status
    end

    # A GET request for a single unpublished project
    test 'returns 401 for unpublished project unauthenticated' do
        get '/v1/projects/2.json'
        assert_equal 401, response.status
    end

    # A GET request for a single unpublished project from a user not the owner
    # or collaborator.
    test 'returns 401 for unpublished no rights' do
        get '/v1/projects/2.json',
            headers: {
                Authorization: 'Bearer 57dd83d2396f06fbcce69bd3d0b4d7cd33a7e102faeff5f745fef06427f96a13'
            }
        assert_equal 401, response.status
    end

    # Check to see if a project has an intro.
    test 'project with intro' do
        get '/v1/projects/1.json'
        require 'pp'
        puts "\n\n\n\n\n\n\n\n\n"
        pp response
        puts "\n\n\n\n\n\n\n\n\n"
        project = JSON.parse(response.body)
        assert_not_nil project['project']['intro']
    end

    # Verifiy a project does not have an into.
    test 'project without intro' do
        get '/v1/projects/3.json'
        project = JSON.parse(response.body)
        assert_nil project['project']['intro']
    end
end
