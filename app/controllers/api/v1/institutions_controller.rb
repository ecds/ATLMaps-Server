class Api::V1::InstitutionsController < ApplicationController
  def index
    institutions = Institution.all.order('name')
    render json: institutions, root: 'institutions'
  end

  def show
    institution = Institution.find(params[:id])
    render json: institution, root: 'institution'
  end
end
