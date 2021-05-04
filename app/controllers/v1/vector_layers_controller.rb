# frozen_string_literal: true

# API response for VectorLayer objects
class V1::VectorLayersController < V1::LayersController
  #
  # Endpoint to list vector layers
  #
  # @return [JSON] Serialized json of vector layers.
  #
  def index
    @serializer =
      if params[:names]
        VectorLayerSerializer
      else
        VectorLayerBaseSerializer
      end
    @layers =
      # if params[:query]
      #   VectorLayer.text_search(params[:query])
      if params[:names]
        VectorLayer.where(name: params[:names].split(','))
      elsif params[:search]
        # NOTE: the client clears out the local store when none of
        # search parameters have values.
        # TODO: Combine all this into one scope.
        VectorLayer.active
                   .browse_text_search(params[:text_search])
                   .by_institution(params[:institution])
                   .spatial_lucene(bounds: make_polygon(params[:bounds]))
                   .by_tags(params[:tags])
                   .by_data_type(params[:type])
      else
        VectorLayer.active.alpha_sort
      end

    # If there is a param of `projectID` were going to send that as an argument to
    # the serializer.
    if params[:projectID]
      render(json: @layers, project_id: params[:projectID]) #, include: ['vector_feature'])
    elsif @layers.empty?
      render(json: { data: [] })
    else
      @layers = @layers.page(params[:page]).per(params[:limit] || 10)
      render(json: @layers, meta: pagination_dict(@layers), each_serializer: @serializer) # , include: ['vector_feature']) # , project_id: 0
    end
  end

  #
  # Endpoint to create new Vectorayer.
  #
  # @return [JSON] Serialized json of newly created Vectorayer.
  #
  def create
    if admin?
      @layer = VectorLayer.new(layer_params)
      if @layer.save
        render(jsonapi: @layer, status: :created)
      else
        render(json: @layer.errors.details, status: :unprocessable_entity)
      end
    else
      render(json: 'Bad credentials', status: :unauthorized)
    end
  end

  #
  # Endpoint to show only meta data for a layer (no GIS data)l
  #
  # @return [JSON] Serialized json of a layer's meta data.
  #
  def meta_only
    layers = VectorLayer.where(name: params[:names].split(','))
    render(json: layers, each_serializer: MetaOnlyLayerSerializer)
  end

  private

  def set_layer
    @layer = VectorLayer.find(params[:id])
  end

  def layer_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(
        params,
        only: %i[
          title
          description
          active
          attribution
          data_format
          url
          default_break_property
        ]
      )
  end
end
