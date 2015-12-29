class Api::V1::UsersController < ApplicationController

  def index
    if current_resource_owner
      # if params[:project_id]
      #   projects = Project.where(name: params[:name])
      # end
      @users = User.where.not(id: current_resource_owner.id)#.where.not('collaboration.project_id' => parmas[:project_id])
    else
      #@users = User.where.not('project_id' => params[:project_id])
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
