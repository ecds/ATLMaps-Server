# frozen_string_literal: true

#
# Helper for making authenticated requests for controller specs.
#
module SignedCookieHelper
  def signed_cookie(user)
    login = EcdsRailsAuthEngine::Login.create!(who: user.email)
    login.user_id = user.id
    login.token = TokenService.create(login)
    login.save!
    cookies.signed[:auth] = {
      value: login.token,
      httponly: true,
      same_site: :none,
      secure: 'Secure'
    }
  end
end
