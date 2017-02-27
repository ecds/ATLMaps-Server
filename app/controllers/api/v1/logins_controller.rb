class Api::V1::LoginsController < ApplicationController
    def create
        login = Login.new(login_params)
        user = User.new(displayname: 'ATLMaps User')
        if user.save
            login.user_id = user.id
        else
            head 500
        end
        if login.save
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
