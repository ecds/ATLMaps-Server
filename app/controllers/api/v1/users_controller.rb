# Controller that retunrns users.
# If the index method sees a parameter of `me` and there is a `current_user`
# assoiated with the call, the user is returned so the frontend can display
# the user's info.
class Api::V1::UsersController < ApplicationController
    # before_action :authenticate!
    def index
        @users = if current_user && params['me']
                     User.where(id: current_user.user.id).first
                 else
                     {}
                 end
        render json: @users
    end

    def show
        # @user = User.find(params[:id])
        render json: current_user.user
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
