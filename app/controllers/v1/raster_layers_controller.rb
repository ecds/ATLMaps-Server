# and the class
class V1::RasterLayersController < ApplicationController
    include PaginationDict
    include MakePolygon

    def index
        @layers = if params[:query]
                      RasterLayer.text_search(params[:query])
                  elsif params[:tagem]
                      RasterLayer.un_tagged
                  elsif params[:names]
                      RasterLayer.where(name: params[:names].split(','))
                  elsif params[:search]
                      # NOTE: the client clears out the local store when none of
                      # search parameters have values.
                      # TODO: Combine all this into one scope.
                      RasterLayer.active
                                 .browse_text_search(params[:text_search])
                                 .by_institution(params[:institution])
                                 .by_year(params[:start_year].to_i, params[:end_year].to_i)
                                 .by_bounds(make_polygon(params[:bounds]))
                                 .by_tags(params[:tags])
                  else
                      RasterLayer.active.alpha_sort
                  end

        # If there is a param of `projectID` we're going to send that as
        # an argument to the serializer.
        if params[:projectID]
            render json: @layers, project_id: params[:projectID]
        elsif @layers.empty?
            render json: { data: [] }
        else
            @layers = @layers.page(params[:page]).per(params[:limit] || 10)
            render json: @layers, meta: pagination_dict(@layers) # , project_id: 0
        end
    end

    def show
        if params[:id]
            @layer = RasterLayer.find(params[:id])
        elsif params[:tagem]
            @layers = RasterLayer.un_tagged
        end
        render json: @layer, root: 'raster_layer', include: ['institution']
    end
end
