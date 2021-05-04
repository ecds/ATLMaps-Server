# frozen_string_literal: true

# Controller to create new login and corrosponding user.
class V1::LoginsController < ApplicationController
  def create
    login = Login.new(login_params)
    # Create user to associate with the login.
    # login.user = User.create(displayname: 'ATLMaps User')
    if login.save
      # If the new user created an account, we send a confirmation email.
      ConfirmLoginMailer.registration_confirmation(login).deliver unless login.provider
      # Ember wants some JSON
      render(json: login.user, status: :created)
    else
      render(json: login.errors.details, status: :bad_request)
    end
  end

  private

  def login_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[identification password])
  end
end
