class Api::V1::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    render json: @user
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
  end
end
