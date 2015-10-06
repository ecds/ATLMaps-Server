# app/controllers/api/v1/projects_controller.rb
module Api
  module V1
    # Controller for repersenting projects
    class ProjectsController < ApplicationController
      # class for Controller
      def index
        if params[:name]
          projects = Project.where(name: params[:name])
        elsif params[:user_id]
          projects = Project.where(user_id: params[:user_id])
        elsif params[:collaborations]
          projects = Project.joins(:collaboration).where(\
            collaborations: { user_id: current_resource_owner.id })
        else
          projects = Project.where(published: true)
        end

        render json: projects, root: 'projects', resource_owner: owner_id
      end

      def show
        # Only return the project if it is published, the user is the owner
        # or the user is a collaborator.
        @project = Project.find(params[:id])
        if @project.published == true || mine == true || collaborator == true
          render json: @project, root: 'project', resource_owner: owner_id
        else
          head 401
        end
      end

      def create
        project = Project.new(project_params)
        if project.save
          head 204
        else
          head 500
        end
      end

      def update
        project = Project.find(params[:id])
        if project.update(project_params)
          head 204
        else
          head 500
        end
      end

      def destroy
        project = Project.find(params[:id])
        if project.user_id == owner_id
          project.destroy
          head 204
        else
          head 401
        end
      end

      private

      def project_params
        params.require(:project).permit(
          :name, :saved, :description, :center_lat, :center_lng, :zoom_level,
          :default_base_map, :user_id, :published)
      end

      def owner_id
        current_resource_owner ? current_resource_owner.id : 0
      end

      def mine
        if current_resource_owner && current_resource_owner.id == @project.user_id
          return true
        else
          return false
        end
      end

      def collaborator
        collaborations = @project.collaboration
        if collaborations.any? and collaborations.include? current_resource_owner.id
          puts current_resource_owner.id
          return true
        elsif mine
          return true
        else
          return false
        end
      end
    end
  end
end
