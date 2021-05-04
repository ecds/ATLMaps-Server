# frozen_string_literal: true

# and the class
class V1::RasterLayersController < V1::LayersController
  include PaginationDict
  include MakePolygon

  #
  # Endpoint to list RasterLayers
  #
  # @return [JSON] Serialized json of raster layers.
  #
  def index
    @layers =
      if params[:names]
        RasterLayer.where(name: params[:names].split(','))
      elsif params[:search]
        # NOTE: the client clears out the local store when none of
        # search parameters have values.
        RasterLayer.active
                   .browse_text_search(params[:text_search])
                   .by_institution(params[:institutions])
                   .spatial_lucene(bounds: make_polygon(params[:bounds]), zoom: params[:zoom])
                   .by_tags(params[:tags])
      else
        RasterLayer.active
      end

    # If there is a param of `projectID` we're going to send that as
    # an argument to the serializer.
    if params[:projectID]
      render(json: @layers, project_id: params[:projectID])
    # elsif @layers.empty?
    #   render(json: { data: [] })
    else
      @layers = @layers.page(params[:page]).per(params[:limit] || 25)
      render(json: @layers, meta: pagination_dict(@layers))
    end
  end

  # Endpoint to show only meta data for a layer (no GIS data)l
  #
  # @return [JSON] Serialized json of a layer's meta data.
  #
  def meta_only
    layers = RasterLayer.where(name: params[:names].split(','))
    render(json: layers, each_serializer: MetaOnlyLayerSerializer)
  end


  #
  # Provides a url for a RasterLayer's attatched thumbnail
  #
  def thumbnail
    set_layer
    if @layer&.thumbnail&.attached?
      redirect_to(rails_blob_url(@layer.thumbnail))
    else
      head(:not_found)
    end
  end

  private

  def set_layer
    @layer = RasterLayer.find(params[:id])
  end
end
