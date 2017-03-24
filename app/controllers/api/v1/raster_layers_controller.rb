# and the class
class Api::V1::RasterLayersController < ApplicationController
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
                                 .by_tags(params[:tags])
                                 .by_year(params[:start_year].to_i, params[:end_year].to_i)
                                 .by_bounds(make_polygon(params[:bounds]))
                  else
                      RasterLayer.active
                  end

        # If there is a param of `projectID` we're going to send that as
        # an argument to the serializer.
        if params[:projectID]
            render json: @layers, project_id: params[:projectID]
            # `active_in_project` attribute will be `false`.
        else
            @layers = Kaminari.paginate_array(@layers).page(params[:page]).per(params[:limit] || 10)
            render json: @layers, meta: pagination_dict(@layers) # , project_id: 0
        end
    end

    def show
        if params[:id]
            @layer = RasterLayer.find(params[:id])
        elsif params[:tagem]
            @layers = RasterLayer.un_tagged
        end
        render json: @layer, root: 'raster_layer'
    end

    def update
        layer = RasterLayer.find(params[:id])
        if layer.update(raster_layer_params)
            head 204
        else
            head 500
        end
    end

    private

    def make_polygon(bounds)
        unless bounds.nil?
            factory = RGeo::Geographic.simple_mercator_factory
            return factory.polygon(
                factory.linear_ring(
                    [
                        factory.point(bounds[:w].to_d, bounds[:n].to_d),
                        factory.point(bounds[:e].to_d, bounds[:n].to_d),
                        factory.point(bounds[:e].to_d, bounds[:s].to_d),
                        factory.point(bounds[:w].to_d, bounds[:s].to_d),
                        factory.point(bounds[:w].to_d, bounds[:n].to_d)
                    ]
                )
            )
        end
    end

    def raster_layer_params
        params.require(:rasterLayer).permit(tag_ids: [])
    end
end
