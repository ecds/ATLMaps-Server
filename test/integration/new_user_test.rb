require 'test_helper'
# test listing projects
class NewUserTest < ActionDispatch::IntegrationTest
    setup { host! 'api.example.com' }

    test 'create new user with password' do
        post '/v1/logins.json',
             params: {
                 login: {
                     identification: 'jackie@treehornprductions.com',
                     password: 'storytelling'

                 }
             }
        assert_equal 201, response.status
    end

    test 'create new user with blank password' do
        post '/v1/logins.json',
             params: {
                 login: {
                     identification: 'jackie@treehornprductions.com'
                 }
             }
        assert_equal 500, response.status
    end

    test 'create new user with blank identification' do
        post '/v1/logins.json',
             params: {
                 login: {
                     password: 'gardenparty'
                 }
             }
        assert_equal 500, response.status
    end
end
