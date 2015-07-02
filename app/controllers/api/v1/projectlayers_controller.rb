class Api::V1::ProjectlayersController < ApplicationController

  def index
    if params[:layer_id]
      projectlayers = Projectlayer.where(layer_id: params[:layer_id]).where( project_id: params[:project_id])
    elsif params[:project_id]
      projectlayers = Projectlayer.where( project_id: params[:project_id])
    else
      projectlayers = Projectlayer.all
    end
    puts projectlayers
    render json: projectlayers, root: 'projectlayers'
  end
  
  def show
    @projectlayer = Projectlayer.find(params[:id])
    render json: @projectlayer, root: 'projectlayer'
  end

  def create
    projectlayer = Projectlayer.new(projectlayer_params)
    if projectlayer.save
      head 204
    end
  end
  
  def destroy
    projectlayer = Projectlayer.find(params[:id])
    projectlayer.destroy
    head 204
  end
  
  private
    def projectlayer_params
      params.require(:projectlayer).permit(:project_id, :layer_id, :marker, :layer_type, :position)
    end
    
end
