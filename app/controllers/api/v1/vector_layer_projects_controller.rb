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
    # Projects from the explore route have an ID of 9999999. We don't want to save that junk.
    # http://www.funnyordie.com/videos/4ecfd3a85f/herman-cains-campaign-promises-with-mike-tyson
    if projectlayer.project
      if mayedit(projectlayer.project) == true
        head 201
      end
    elsif current_resource_owner && vector_layer_project_params[:project_id] != '9999999'
      head 201
    else
      head 401
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
      params.require(:vectorLayerProject).permit(:project_id, :vector_layer_id, :marker, :layer_type, :position)
    end

end
