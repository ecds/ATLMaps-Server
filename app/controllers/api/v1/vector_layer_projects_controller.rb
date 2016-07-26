class Api::V1::VectorLayerProjectsController < ApplicationController
  def index
    if params[:vector_layer_id]
      projectlayers = VectorLayerProject.where(vector_layer_id: params[:vector_layer_id]).where( project_id: params[:project_id])
    elsif params[:project_id]
      projectlayers = VectorLayerProject.where( project_id: params[:project_id])
    else
      projectlayers = VectorLayerProject.all
    end

    render json: projectlayers
  end

  def show
    @projectlayer = VectorLayerProject.find(params[:id])
    render json: @projectlayer
  end

  def create
    projectlayer = VectorLayerProject.new(vector_layer_project_params)
    if current_resource_owner
      if projectlayer.save
        # Ember wants some JSON
        render json: projectlayer, status: 201
      else
        head 500
      end
    else
      head 401
    end
  end

  def update
    project = VectorLayerProject.find(params[:id])
    if project.update(vector_layer_project_params)
      head 204
    else
      head 500
    end
  end

  def destroy
    projectlayer = VectorLayerProject.find(params[:id])
    if mayedit(projectlayer.project) == true
      projectlayer.destroy
      head 204
    else
      head 401
    end
  end

  private
    def vector_layer_project_params
      params.require(:vectorLayerProject).permit(:project_id, :vector_layer_id, :marker, :data_format, :position)
    end

end
