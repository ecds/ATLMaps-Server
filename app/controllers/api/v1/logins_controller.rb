# Controller to create new login and corrosponding user.
class Api::V1::LoginsController < ApplicationController
    def create
        login = Login.new(login_params)
        # Create user to associate with the login.
        login.user = User.create(displayname: 'ATLMaps User')
        if login.save
            # If the new user created an account, we send a confirmation email.
            unless login.provider
                ConfirmLoginMailer.registration_confirmation(login).deliver
            end
            # Ember wants some JSON
            render json: login, status: 201
        else
            head 500
        end
    end

    private

    def login_params
        params.require(:login).permit(:identification, :password)
    end
end
