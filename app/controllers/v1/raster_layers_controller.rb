# frozen_string_literal: true

# and the class
class V1::RasterLayersController < ApplicationController
  include PaginationDict
  include MakePolygon

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def index
    @layers =
      # if params[:query]
      #   RasterLayer.text_search(params[:query])
      # elsif params[:tagem]
      #   RasterLayer.un_tagged
      if params[:names]
        RasterLayer.where(name: params[:names].split(','))
      elsif params[:search]
        # NOTE: the client clears out the local store when none of
        # search parameters have values.
        RasterLayer.active
                   .browse_text_search(params[:text_search])
                   .by_institution(params[:institutions])
                   .by_year(params[:start_year].to_i, params[:end_year].to_i)
                   .spatial_lucene(bounds: make_polygon(params[:bounds]), zoom: params[:zoom])
                   .by_tags(params[:tags])
      else
        RasterLayer.active#.spatial_sort
      end

    # If there is a param of `projectID` we're going to send that as
    # an argument to the serializer.
    if params[:projectID]
      render(json: @layers, project_id: params[:projectID])
    # elsif @layers.empty?
    #   render(json: { data: [] })
    else
      @layers = @layers.page(params[:page]).per(params[:limit] || 25)
      render(json: @layers, meta: pagination_dict(@layers)) # , project_id: 0
    end
  end

  def show
    @layer = RasterLayer.find(params[:id])
    render(json: @layer, root: 'raster_layer', include: %w[institution])
  end

  def thumbnail
    @layer = RasterLayer.find(params[:id])
    if @layer && @layer.thumbnail.attached?
      redirect_to rails_blob_url(@layer.thumbnail)
    else
      head :not_found
    end
  end
end

