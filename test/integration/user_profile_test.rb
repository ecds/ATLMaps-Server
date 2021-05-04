# frozen_string_literal: true

require('test_helper')
# include 'pp'

class ProjectCrudTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  # A POST request to create a project unauthenticated
  # test 'update profile' do
  #     @user = User.find(1)
  #     put '/v1/users.json',
  #         params: {
  #             id: 1,
  #             displayname: 'Karl Marx'
  #         },
  #         headers: {
  #             Authorization: 'Bearer a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
  #         }
  #     assert_equal 204, response.status
  #
  #     # Make sure it presisted.
  #     get '/v1/users.json',
  #         params: {
  #             me: true
  #         },
  #         headers: {
  #             Authorization: 'Bearer a03832787c0c21e46e72c0be225e4a9bb9c189451a3bc002a99d4741425163cf'
  #         }
  #     assert_equal 'Karl Marx', JSON.parse(response.body)['user']['displayname']
  # end
end
