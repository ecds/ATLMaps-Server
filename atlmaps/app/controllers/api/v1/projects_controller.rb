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
  
  def index
    @projects = Project.all
    render json: @projects
    #respond_to do |format|
    #  format.json { render json: projects, status: :ok }
    #end
  end
  
  def show
    @project = Project.find(params[:id])
    render json: @project
    #respond_to do |format|
    #  format.json { render json: project, status: :ok }
    #end
  end
  
  def create
    project = Project.new(project_params)
    if project.save
      head 204, location: project
    end
  end
  
  private
    def project_params
      params.require(:project).permit(:name, :status)
    end
  
end
