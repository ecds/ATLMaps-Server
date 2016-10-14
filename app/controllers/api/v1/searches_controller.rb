class Api::V1::SearchesController < ApplicationController

  # @!method Index method for searches.
  # @todo This is really just awful and ther has to be a be a way to dry this up. This whole thing makes me sad :(
  def index
    @rasters = RasterLayer.browse_text_search(params[:text_search]).by_institution( params[:name] )
                .by_tags( params[:tags] ).by_year( params[:start_year].to_i, params[:end_year].to_i)
                .active()
    # @todo There has to be a better way to do this. The reason this is hers is that I can't figure out how to make the Arel based scope fire conditionally
    if params[:bounds].present?
      @rasters = @rasters.by_bounds( make_polygon(params[:bounds]))
    end

    @vectors = VectorLayer.browse_text_search(params[:text_search]).by_institution( params[:name] )
                .by_tags( params[:tags] ).by_year( params[:start_year].to_i, params[:end_year].to_i)
                .active()

    # Without this, we will return everything if the user clears out previous search options.
	 if(params[:tags].blank? && params[:start_year].blank? && params[:finish_year].blank? && params[:name].blank? && params[:text_search].blank? && params[:bounds].blank?)
	 	@rasters = []
	 	@vectors = []
	 end
      # The goal is to provide an array of ids for vector and raster layers that
      # match the filter. Sometimes a layer might satisify multiple filters, hence
      # the `.uniq`.
      @searches = {
        :searches => {
          # This feels hackey but Ember Data requires the object to have an ID
    	      :id => 1,
    	      :raster_layer_ids => (@rasters.ids.uniq if @rasters.any?),
    	      :vector_layer_ids => (@vectors.ids.uniq if @vectors.any?)
        }
      }

  render json: @searches, meta: pagination_dict(@searches)
  end

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
end
