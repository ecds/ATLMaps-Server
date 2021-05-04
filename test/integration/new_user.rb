# frozen_string_literal: true

require('test_helper')
# test listing projects
class NewUserTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  test 'create new user with password' do
    post '/v1/login.json',
         params: {
           login: {
             identification: 'jackie@treehornprductions.com',
             password: 'storytelling'
           }
         }
    puts response.body
    assert_equal 201, response.status
  end
end
