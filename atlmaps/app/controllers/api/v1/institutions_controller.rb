class Api::V1::InstitutionsController < ApplicationController
  def index
    institutions = Institution.all
    render json: institutions
  end
  
  def show
    institution = Institution.find(params[:id])
    render json: institution
  end
end
