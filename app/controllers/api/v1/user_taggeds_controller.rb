class Api::V1::UserTaggedsController < ApplicationController
    def create
        usertagged = UserTagged.new(usertagged_params)
        # if current_resource_owner
        if usertagged.save
            # Ember wants some JSON
            render json: UserTagged, status: 201
        else
            head 500
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
