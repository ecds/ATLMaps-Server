class Api::V1::VectorLayersController < ApplicationController
    def index
        if params[:query]
            @layers = VectorLayer.text_search(params[:query])
        else
            @layers = VectorLayer.where(active: true).includes(:projects, :tags, :institution)
        end

        # If there is a param of `projectID` were going to send that as an argument to
        # the serializer.
        if params[:projectID]
            render json: @layers, project_id: params[:projectID]
        # Otherwise, we're just going to say that the `project_id` is `0` so the
        # `active_in_project` attribute will be `false`.
        else
            render json: @layers, project_id: 0
        end
    end

  def show
      layer = VectorLayer.find(params[:id])
    #end
    render json: layer
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
  end

  # I don't think we need this anymore
  # def update
  #   project = Project.find(params[:id])
  #   if project.update_attributes(params[:name])
  #     head 204, location: project
  #   end
  # end

  #private
  #  def project_params
  #    params.permit(:project_ids => [])
  #  end

end
