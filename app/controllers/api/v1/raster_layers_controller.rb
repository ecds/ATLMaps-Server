class Api::V1::RasterLayersController < ApplicationController

    def index
        # Not sure this is still needed
        # if params[:raster_layer]
        # 	@layers = RasterLayer.where(layer: params[:layer])
        if params[:query]
            @layers = RasterLayer.text_search(params[:query])
        # elsif params[:tagem].include? '-'
        #     @layers = RasterLayer.where(name: params[:tagem].split('-')[1]).first
        elsif params[:tagem]
            @layers = RasterLayer.un_tagged
        elsif params[:search]
            # We always expect search, subomain, controller, format, and action
            # be preesent.
            if params.length <= 5
                @layers = RasterLayer.none
            else
                @layers = RasterLayer.active()
                # @todo do we need the .present? here and on the
                @layers = @layers.browse_text_search(params[:text_search]) if params[:text_search].present?
                @layers = @layers.by_institution(params[:institution]) if params[:institution].present?
                @layers = @layers.by_tags(params[:tags]) if params[:tags].present?
                @layers = @layers.by_year(params[:start_year].to_i, params[:end_year].to_i) if params[:end_year].present?
                if params[:bounds] != false
                    puts params[:bounds]
                    @layers = @layers.by_bounds(make_polygon(params[:bounds])) if params[:bounds].present?
                end
            end
        else
            @layers = RasterLayer.active
        end

        # If there is a param of `projectID` we're going to send that as an argument to
        # the serializer.
        if params[:projectID]
            render json: @layers, project_id: params[:projectID]
        # Otherwise, we're just going to say that the `project_id` is `0` so the
        # `active_in_project` attribute will be `false`.
        else
            @layers = @layers.page(params[:page]).per(params[:limit] || 10)
            render json: @layers, meta: pagination_dict(@layers) # , project_id: 0
        end
    end

    def show
        layer = RasterLayer.find(params[:id])
        # Not sure this conditional is still needed
        # if params[:projectID]
        # 	render json: layer, root: 'raster_layer', project_id: params[:projectID]
        # else
        # 	render json: layer, root: 'raster_layer'
        # end
        render json: layer, root: 'raster_layer'
    end

    def update
        layer = RasterLayer.find(params[:id])
        if layer.update(raster_layer_params)
            puts 'what'
            head 204
        else
            head 500
        end
    end

    private

    def make_polygon(bounds)
      if bounds != nil
        factory = RGeo::Geographic.simple_mercator_factory
        nw = factory.point(bounds[:w].to_d, bounds[:n].to_d)
        ne = factory.point(bounds[:e].to_d, bounds[:n].to_d)
        se = factory.point(bounds[:e].to_d, bounds[:s].to_d)
        sw = factory.point(bounds[:w].to_d, bounds[:s].to_d)
        polly =  factory.polygon(
          factory.linear_ring([nw, ne, se, sw, nw])
        )

        return polly
      else
        return nil
      end
    end

    def raster_layer_params
        params.require(:rasterLayer).permit(tag_ids: [])
    end
end
