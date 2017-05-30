# API response for VectorLayer objects
class Api::V1::VectorLayersController < ApplicationController
    include MakePolygon, PaginationDict

    def index
        @layers = if params[:query]
                      VectorLayer.text_search(params[:query])
                  elsif params[:names]
                      VectorLayer.where(name: params[:names].split(','))
                  elsif params[:search]
                      # NOTE: the client clears out the local store when none of
                      # search parameters have values.
                      # TODO: Combine all this into one scope.
                      VectorLayer.active
                                 .browse_text_search(params[:text_search])
                                 .by_institution(params[:institution])
                                 .by_year(params[:start_year].to_i, params[:end_year].to_i)
                                 .by_bounds(make_polygon(params[:bounds]))
                                 .by_tags(params[:tags])
                  else
                      VectorLayer.active.alpha_sort
                  end

        # If there is a param of `projectID` were going to send that as an argument to
        # the serializer.
        if params[:projectID]
            render json: @layers, project_id: params[:projectID], include: ['vector_feature']
        elsif @layers.empty?
            render json: { data: [] }
        else
            @layers = @layers.includes(:vector_feature).page(params[:page]).per(params[:limit] || 10)
            render json: @layers, meta: pagination_dict(@layers), include: ['vector_feature'] # , project_id: 0
        end
    end

    def show
        layer = VectorLayer.find(params[:id])
        # end
        render json: layer, include: ['vector_feature']
        # respond_to do |format|
        #  format.json { render json: layer, status: :ok }
        # end
    end

    def create
        if current_user && current_user.confirmed
            # project_params['user_id'] = current_user.user.id
            layer = VcetorLayer.new(layer_params)
            layer.user = current_user.user
            if layer.save
                # Ember wants some JSON
                render json: layer, status: 201
            else
                head 500
            end
        else
            head 401
        end
    end
end
