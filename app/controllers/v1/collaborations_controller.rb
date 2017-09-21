class V1::CollaborationsController < ApplicationController
    def index
        collaborations = if params[:project_id]
                             Collaboration.where(user_id: params[:user_id]).where(project_id: params[:project_id]).limit(1)
                         else
                             Collaboration.all
                         end
        render json: collaborations
    end

    def show
        collaboration = Collaboration.find(params[:id])
        render json: collaboration
    end

    def create
        collaboration = Collaboration.new(collaboration_params)
        head 204 if collaboration.save
    end

    def destroy
        collaboration = Collaboration.find(params[:id])
        collaboration.destroy
        head 204
    end

    private

    def collaboration_params
        ActiveModelSerializers::Deserialization .jsonapi_parse(params, only: %i[project_id user_id])
    end
end
