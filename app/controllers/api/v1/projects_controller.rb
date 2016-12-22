# app/controllers/api/v1/projects_controller.rb
module Api
    module V1
        # Controller for repersenting projects
        class ProjectsController < MayEditController
            # class for Controller
            def index
                if params[:name]
                    projects = Project.where(name: params[:name]).first
                elsif params[:user_id]
                    projects = Project.where(user_id: params[:user_id])
                # elsif params[:collaborations]
                #     projects = Project.joins(:collaboration).where(\
                #         collaborations: { user_id: params[:user_id] })
                elsif params[:featured]
                    projects = Project.where(featured: true)
                else
                    projects = Project.where(published: true)
                end

                render json: projects
            end

            def show
                @project = Project.find(params[:id])
                # Only return the project if it is published, the user is the owner
                # or the user is a collaborator.
                if @project.published == true || may_edit(@project) == true #|| collaborator(@project) == true
                    render json: @project, root: 'project', is_mine: mine(@project), may_edit: may_edit(@project)
                else
                    head 401
                end
            end

            def create
                project = Project.new(project_params)
                if @current_login
                    if project.save
                        # Ember wants some JSON
                        render json: project, status: 201
                    else
                        head 500
                    end
                else
                    head 401
                end
            end

            def update
                @project = Project.find(params[:id])
                if may_edit(@project) == true
                    if @project.update(project_params)
                        render json: {}, status: 204
                    else
                        head 500
                    end
                else
                    head 401
                end
            end

            def destroy
                project = Project.find(params[:id])
                if may_edit(project)
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
                    :default_base_map, :user_id, :published, :featured, :intro, :media, :photo, :template_id)
            end
        end
    end
end
