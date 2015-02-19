class Api::V1::CollaborationsController < ApplicationController
  def index
    if params[:project_id]
      collaborations = Collaboration.where(user_id: params[:user_id]).where( project_id: params[:project_id])
    else
      collaborations = Collaboration.all
    end
    render json: collaborations
  end
  
  def show
    collaboration = Collaboration.find(params[:id])
    render json: collaboration
  end

  def create
    collaboration = Collaboration.new(collaboration_params)
    if collaboration.save
      head 204
    end
  end
  
  def destroy
    collaboration = Collaboration.find(params[:id])
    collaboration.destroy
    head 204
  end
  
  private
    def collaboration_params
      params.require(:collaboration).permit(:project_id, :user_id)
    end
end
