# frozen_string_literal: true

# Controller class for Institutions
class V1::InstitutionsController < ApplicationController
  def index
    @institutions =
      if params[:limit]
        Institution.all.order('name').reject { |i| i.vector_layers.empty? && i.raster_layers.empty? }
      else
        Institution.all.order('name')
      end
    render(json: @institutions)
  end

  def show
    institution = Institution.find(params[:id])
    render(json: institution)
  end
end
