class Api::V1::ProjectsController < ApplicationController

  def index
    if params[:name]
      projects = Project.where(name: params[:name])
    elsif params[:published]
      if current_resource_owner
      end
      projects = Project.where(published: true)
    elsif params[:user_id]
      projects = Project.where(user_id: params[:user_id]).where(saved: true)
    elsif params[:collaborations]
      projects = Project.joins(:collaboration).where(collaborations: {user_id: current_resource_owner.id})
    else
      projects = Project.all
    end

    render json: projects, root: 'projects', resource_owner: owner_id
    #respond_to do |format|
    #  format.json { render json: projects, status: :ok }
    #end
  end

  def show
    #if params[:id]
    @project = Project.find(params[:id])
    #elsif params[:slug]
      #@project = Project.where(name: params[:id])
    #end

    # if current_resource_owner
    #   @may_edit = is_collaborator

    #   @is_mine = is_mine

    # else
    #   if @project.owner == 'Guest'
    #     @may_edit = true
    #   end
    # end
    render json: @project, root: 'project', resource_owner: owner_id

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

    def owner_id
      # if current_resource_owner
      #   return current_resource_owner.id
      # else
      #   return 0
      # end
      return current_resource_owner ? current_resource_owner.id : 0
    end

    def is_mine
      if current_resource_owner && current_resource_owner.id == @project.user_id
        return true
      else
        return false
      end
    end

    def is_collaborator
      collaborations = []
      @project.collaboration.each do |collaborator|
        collaborations << collaborator.user_id
      end
      if collaborations.any? and collaborations.include? current_resource_owner.id
        return true
      elsif is_mine
        return true
      else
        return false
      end
    end
          

    # def current_resource_owner
    #   User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    # end

end