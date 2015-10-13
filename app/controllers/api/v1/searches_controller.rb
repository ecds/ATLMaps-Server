class Api::V1::SearchesController < ApplicationController
  
  respond_to :json, :html, :xml 
  
  def index
  	if request.post?
	    @layers = RasterLayer.all.by_institution( params[:name] )
	    						.by_tags( params[:tags] ).by_date( params[:start_date], params[:end_date])
	    @vectors = VectorLayer.all.by_institution( params[:name])
	    						.by_tags( params[:tags] ).by_date( params[:start_date], params[:end_date])
	end
	@response = { :layers => @layers, :vectors => @vectors }

			
	render json: @response, root: 'searches'
  end
  
  
end