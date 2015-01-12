class Api::V1::ProfilesController < ApplicationController
  def show
    profile = Profile.find(params[:id])
    render json: profile
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
  end
end
