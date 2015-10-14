class Api::V1::SearchesController < ApplicationController


  def index
  	# if request.post?
	    @layers = RasterLayer.all.by_institution( params[:name] )
	    						.by_tags( params[:tags] ).by_date( params[:start_date], params[:end_date])
	    @vectors = VectorLayer.all.by_institution( params[:name])
	    						.by_tags( params[:tags] ).by_date( params[:start_date], params[:end_date])
	# end
	@searches = {:searches => {:raster_layer_ids => @layers.as_json(only: [:id]), :vector_layer_ids => @vectors.as_json(only: [:id])}}



  render json: @searches
  end


end
