class Api::V1::VectorFeaturesController < ApplicationController

    def show
        feature = VectorFeature.find(params[:id])
        # end
        render json: feature
        # respond_to do |format|
        #  format.json { render json: layer, status: :ok }
        # end
    end
end
