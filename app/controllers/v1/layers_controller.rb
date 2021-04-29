# frozen_string_literal: true

# API response for VectorLayer objects
class V1::LayersController < ApplicationController
  include Permissions
  include PaginationDict
  include MakePolygon

  before_action :set_layer, except: %i(index create meta_only)

  #
  # Endpoint for listing objects.
  #
  # Subclasses must implement their own index function.
  #
  def index
    raise NotImplementedError, 'A layer class should implement its own `index` function.'
  end

  #
  # Endpoint to show layer.
  #
  # @return [JSON] Serialized json of layer.
  #
  def show
    render(json: @layer)
  end

  #
  # Endpoint to update VectorLayer
  #
  # @return [JSON] Serialized json of updated VectorLayer.
  #
  def update
    if admin?
      if @layer.update(layer_params)
        # render json: @stop
        head(:no_content)
      else
        render(json: @layer.errors, status: :unprocessable_entity)
      end
    else
      render(json: 'Bad credentials', status: :unauthorized)
    end
  end

  #
  # Endpoint to delete VecorLayer
  #
  def destroy
    if admin?
      @layer.destroy!
      head(204)
    else
      head(401)
    end
  end

  #
  # Endpoint for creating objects.
  #
  # Subclasses must implement their own create function.
  #
  def create
    raise NotImplementedError, 'A layer class should implement its own `create` function.'
  end

  # Endpoint to show only meta data for a layer (no GIS data)l
  #
  # @return [JSON] Serialized json of a layer's meta data.
  #
  def meta_only
    raise NotImplementedError, 'A layer class should implement its own `meta_only` function.'
  end

  private

  def set_layer
    raise NotImplementedError, 'A layer class should implement its own `set_layer` function.'
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
