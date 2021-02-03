# frozen_string_literal: true


#
# <Description>
#
class Uploads::VectorController < ApplicationController
  require 'zip'
  #
  # Return list of properties from uploaded file.
  #
  # @return [JSON] List of attributes in data
  #
  def parse
    vu = VectorUpload.new(file: params[:fileToParse])
    render(json: { attributes: vu.set_attributes }, status: :ok)
  rescue StandardError => e
    render(json: { message: e }, status: :bad_request)
  end

  #
  # Render GeoJSON with updated properties.
  #
  # @return [JSON] GeoJSON with updated properties.
  #
  def preview
    if params[:mappedAttributes].nil?
      render(json: { message: 'Missing attribute options.' }, status: :bad_request)
    elsif params[:file].nil?
      render(json: { message: 'Missing layer file.' }, status: :bad_request)
    else
      mapped_attributes = JSON.parse(params[:mappedAttributes], symbolize_names: true).compact
      begin
        vu = VectorUpload.new(file: params[:file], mapped_attributes: mapped_attributes)
      rescue Exception => e
        render(json: { message: e }, status: :bad_request)
        return
      end
      begin
        render(json: vu.amend_attributes, status: :ok)
      rescue Exception => e
        Rails.logger.debug("GRRRR: #{e.backtrace}")
        render(json: { message: e }, status: :bad_request)
      end
    end
  end

  #
  # Handle request to create new Shapefile.
  #
  # @return [JSON] Success or failure message.
  #
  def new
    if params[:file].nil?
      render(json: { message: 'Missing json file.' }, status: :bad_request)
    elsif params[:geojson].nil?
      render(json: { message: 'Missing geoson string.' }, status: :bad_request)
    elsif params[:title].nil?
      render(json: { message: 'Missing title for layer.' }, status: :bad_request)
    else
      vu = VectorUpload.new(file: params[:file])

      layer = vu.make_vector_layer(params)

      render(json: { message: 'success', layerId: layer.id, layerTitle: layer.title }, status: :ok)
    end
  end
end
