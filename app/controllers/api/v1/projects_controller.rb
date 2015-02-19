class Api::V1::ProjectsController < ApplicationController
  
  #after_filter :cors_set_access_control_headers
  #
  ## For all responses in this controller, return the CORS access control headers. 
  #def cors_set_access_control_headers
  #  headers['Access-Control-Allow-Origin'] = '*'
  #  headers['Access-Control-Allow-Headers'] = 'X-AUTH-TOKEN, X-API-VERSION, X-Requested-With, Content-Type, Accept, Origin'
  #  headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
  #  headers['Access-Control-Max-Age'] = "1728000"
  #end
  #before_action -> { doorkeeper_authorize! :public }, only: :index
  def index
    if params[:name]
      projects = Project.where(name: params[:name])
    elsif params[:published]
      projects = Project.where(published: true)
    elsif params[:user_id]
      projects = Project.where(user_id: params[:user_id]).where(saved: true)
    else
      if current_resource_owner
        logger.warn current_resource_owner.displayname
      end
      projects = Project.all
    end
    render json: projects
    #respond_to do |format|
    #  format.json { render json: projects, status: :ok }
    #end
  end
  
  def show
    project = Project.find(params[:id])
    render json: project
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
    #@project = Project.find(params[:id])
    #@layer_ids = []
    #layers = Projectlayer.select(:layer_id).where(:project_id => params[:id])
    #layers.each do |layer|
    #  @layer_ids << layer.layer_id
    #end
  end
  
  def create
    project = Project.new(project_params)
    if project.save
      head 204
    end
  end
  
  def update
    project = Project.find(params[:id])
    if project.update(project_params)
      head 204
    end
  end
  
  def destroy
    project = Project.find(params[:id])
    project.destroy
    head 204
  end
  
  private
    def project_params
      params.require(:project).permit(:name, :saved, :description, :user_id, :published)
    end
    
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  
end

