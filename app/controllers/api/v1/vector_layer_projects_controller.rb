class Api::V1::VectorLayerProjectsController < ApplicationController
  def index
    if params[:vector_layer_id]
      projectlayers = VectorLayerProject.where(vector_layer_id: params[:vector_layer_id]).where( project_id: params[:project_id])
    elsif params[:project_id]
      projectlayers = VectorLayerProject.where( project_id: params[:project_id])
    else
      projectlayers = VectorLayerProject.all
    end

    render json: projectlayers, root: 'vector_layer_project'
  end
  
  def show
    @projectlayer = VectorLayerProject.find(params[:id])
    render json: @projectlayer, root: 'vector_layer_project'
  end

  def create
    projectlayer = VectorLayerProject.new(vector_layer_project_params)
    if projectlayer.save
      head 204
    end
  end
  
  def destroy
    projectlayer = VectorLayerProject.find(params[:id])
    projectlayer.destroy
    head 204
  end
  
  private
    def vector_layer_project_params
      params.require(:vectorLayerProject).permit(:project_id, :vector_layer_id, :marker, :layer_type, :position)
    end
    
end
