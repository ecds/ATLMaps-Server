class Api::V1::SearchesController < ApplicationController

  def index
    @rasters = RasterLayer.browse_text_search(params[:text_search]).by_institution( params[:name] )
                .by_tags( params[:tags] ).by_year( params[:start_year].to_i, params[:end_year].to_i)
    @vectors = VectorLayer.browse_text_search(params[:text_search]).by_institution( params[:name] )
                .by_tags( params[:tags] ).by_year( params[:start_year].to_i, params[:end_year].to_i)

	 if(!params.has_key?(:tags) && !params.has_key?(:start_year) && !params.has_key?(:finish_year) && !params.has_key?(:name))
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

  render json: @searches
  end
end
