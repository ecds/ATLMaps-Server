class Api::V1::VectorLayersController < ApplicationController
    def index
        if params[:query]
            @layers = VectorLayer.text_search(params[:query])
        elsif params[:names]
            @layers = VectorLayer.where(name: params[:names].split(',')) || []
        elsif params[:search]
            # We always expect search, subomain, controller, format, and action
            # be preesent.
            # @todo do we need the .present? here and on the
            @layers = VectorLayer.active
            @layers = @layers.browse_text_search(params[:text_search]) if params[:text_search].present?
            @layers = @layers.by_institution(params[:institution]) if params[:institution].present?
            @layers = @layers.by_tags(params[:tags]) if params[:tags].present?
            @layers = @layers.by_year(params[:start_year].to_i, params[:end_year].to_i) if params[:end_year].present?
            # @layers = Kaminari.paginate_array(@layers).page(params[:page]).per(params[:limit] || 10)

            # end
        else
            @layers = VectorLayer.where(active: true).includes(:projects, :tags, :institution)
        end

        # If there is a param of `projectID` were going to send that as an argument to
        # the serializer.
        if params[:projectID]
            render json: @layers, project_id: params[:projectID]
        elsif @layers.empty?
            render json: { vector_layers: [] }
        # Otherwise, we're just going to say that the `project_id` is `0` so the
        # `active_in_project` attribute will be `false`.
        else
            # render json: @layers, project_id: 0
            @layers = Kaminari.paginate_array(@layers).page(params[:page]).per(params[:limit] || 10)
            render json: @layers, meta: pagination_dict(@layers) # , project_id: 0
        end
    end

    def show
        layer = VectorLayer.find(params[:id])
        # end
        render json: layer
        # respond_to do |format|
        #  format.json { render json: layer, status: :ok }
        # end
    end

    # I don't think we need this anymore
    # def update
    #   project = Project.find(params[:id])
    #   if project.update_attributes(params[:name])
    #     head 204, location: project
    #   end
    # end

    # private
    #  def project_params
    #    params.permit(:project_ids => [])
    #  end
end
