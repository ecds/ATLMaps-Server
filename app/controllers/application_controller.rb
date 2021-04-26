# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # before_action
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  # skip_before_filter :verify_authenticity_token, if: proc { |c| c.request.format == 'application/json' }

  include EcdsRailsAuthEngine::CurrentUser
  include ActionController::MimeResponds
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  before_action :set_host_for_active_storage

  # protect_from_forgery with: :exception

  # Method to get the user ID associated with the token being used.
  # def current_user
  #     auth_header = request.headers['Authorization']
  #     return auth_header ? Login.where(oauth2_token: auth_header.split(' ').last).first : false
  # end

  private

  def default_serializer_options; end

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = {
      value: form_authenticity_token,
      same_site: :none,
      secure: 'Secure'
    }
  end

  def set_host_for_active_storage
    Rails.application.routes.default_url_options[:host] = request.base_url
  end
end
