# Controller that retunrns users.
# If the index method sees a parameter of `me` and there is a `current_user`
# assoiated with the call, the user is returned so the frontend can display
# the user's info.
class Api::V1::UsersController < ApplicationController
    # before_action :authenticate!
    def index
        if current_user && params['me'] && current_user.confirmed
            #  User.where(id: current_user.user.id).first
            render json: current_user.user
        elsif !current_user.confirmed
            render json: { errors: "Check email for #{current_user.identifier} for confirmation email." }.to_json, status: 401
        else
            render json: {}.to_json, status: 401
        end
    end

    def show
        # @user = User.find(params[:id])
        # unless current_user.user.confirmed
        #     render json: { errors: { msg: 'You must confirm your email.' } }.to_json, status: 200
        #     return true
        # end
        render json: current_user.user
    end

    def create
        user = User.new(user_params)
        if user.save && user.create_login(login_params)
            head 200
        else
            head 422 # you'd actually want to return validation errors here
        end
    end

    def update
        if current_user.user.update(user_params)
            user = current_user.user
            render json: user, status: 204
        else
            head 500
        end
    end

    private

    def user_params
        params.permit(
            :displayname
        )
    end
end
