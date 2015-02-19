class Api::V1::UsersController < ApplicationController
  
  def index
    if current_resource_owner
      @users = User.where.not(id: current_resource_owner.id)
    else
      @users = User.all
    end
    render json: @users
  end
  
  def show
    @user = User.find(params[:id])
    render json: @user
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
  end
end
