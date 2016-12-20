class Api::V1::UserTaggedsController < ApplicationController

    def index
      @usertagged = UserTagged.where(user_id: params[:user_id], raster_layer_id: params[:raster_layer_id])
      render json: @usertagged, root: 'user_taggeds', status: 200
    end

    def create
        usertagged = UserTagged.new(usertagged_params)
        # if @current_login
        if usertagged.save
            # Ember wants some JSON
            render json: usertagged, root: 'user_tagged', status: 201
        else
            puts usertagged.errors.inspect
            render json: usertagged.errors, status: 500
        end
        # else
        #   head 401
        # end
    end

    private

    def usertagged_params
        params.require(:userTagged).permit(
            :tag_id, :user_id,
            :raster_layer_id,
            :vector_layer_id
        )
    end
end
