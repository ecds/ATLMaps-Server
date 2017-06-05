# Controller to create new login and corrosponding user.
class Api::V1::LoginsController < ApplicationController
    def create
        login = Login.new(login_params)
        # Create user to associate with the login.
        # login.user = User.create(displayname: 'ATLMaps User')
        if login.save
            # If the new user created an account, we send a confirmation email.
            unless login.provider
                ConfirmLoginMailer.registration_confirmation(login).deliver
            end
            # Ember wants some JSON
            render json: login.user, status: 201
        else
            render json: login.errors.details, status: 400
        end
    end

    private

    def login_params
        ActiveModelSerializers::Deserialization .jsonapi_parse(params, only: [:identification, :password])
    end
end
