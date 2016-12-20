# FIXME: get rid of this and do it on the client side http://emberigniter.com/real-world-authentication-with-ember-simple-auth/
# Got this code for here http://stackoverflow.com/a/25532347/1792144
# The point of this is to inject the user's details into the response
class CustomTokensController < Doorkeeper::TokensController
  # 
  # # Overriding create action
  # # POST /oauth/token
  # def create
  #   puts '!!!!!!!!!!!!!'
  #   puts server.token_request params[:grant_type]
  #   response = authorize_response
  #   puts response
  #   puts '%%%%%%%%%%%%%'
  #   body = response.body
  #
  #   if response.status == :ok
  #     # User the resource_owner_id from token to identify the user
  #     user = User.find(response.token.resource_owner_id) rescue nil
  #
  #     unless user.nil?
  #       ### If you want to render user with template
  #       ### create an ActionController to render out the user
  #       # ac = ActionController::Base.new()
  #       # user_json = ac.render_to_string( template: 'api/users/me', locals: { user: user})
  #       # body[:user] = Oj.load(user_json)
  #
  #       ### Or if you want to just append user using 'as_json'
  #       body[:user] = user.as_json
  #     end
  #   end
  #
  #   self.headers.merge! response.headers
  #   self.response_body = body.to_json
  #   self.status        = response.status
  #
  # rescue Doorkeeper::Errors::DoorkeeperError => e
  #   handle_token_exception e
  # end
end
