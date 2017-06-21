# app/controllers/api/v1/projects_controller.rb
class Api::V1::ProjectsController < Api::V1::PermissionController
    # class for Controller
    include RailsApiAuth::Authentication
    def index
        render json: if params['user_id'] && current_user
                         Project.where(user_id: current_user.user.id)
                     else
                         Project.featured
                     end
    end

    def show
        project = Project.includes(vector_layer_project: [{ vector_layer: :vector_feature }]).find(params[:id])
        # Only return the project if it is published, the user is the owner
        # or the user is a collaborator.
        permissions = ownership(project)
        if project.published == true || permissions[:may_edit] == true
            render json: project,
                   root: 'project',
                   may_edit: permissions[:may_edit],
                   mine: permissions[:mine],
                   include: [
                       'vector_layer_project',
                       'vector_layer_project.vector_layer',
                       'vector_layer_project.vector_layer.vector_feature',
                       'raster_layer_project',
                       'raster_layer_project.raster_layer',
                       'vector_layer_project.vector_layer.institution',
                       'raster_layer_project.raster_layer.institution'
                   ]
        else
            render json: { errors: 'permission denied' }.to_json, status: 401
        end
    end

    def create
        if current_user && current_user.user.confirmed
            # project_params['user_id'] = current_user.user.id
            project = Project.new(project_params)
            project.saved = true
            project.user = current_user.user
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
        permissions = ownership(@project)
        if permissions[:may_edit] == true
            if @project.update(project_params)
                render json: @project, status: 204
            else
                head 500
            end
        else
            head 401
        end
    end

    def destroy
        project = Project.find(params[:id])
        permissions = ownership(project)
        if permissions[:mine]
            project.destroy
            head 204
        else
            head 401
        end
    end

    private

    def project_params
        ActiveModelSerializers::Deserialization
            .jsonapi_parse(
                params, only: [
                    :name, :saved, :description,
                    :center_lat, :center_lng,
                    :zoom_level, :default_base_map,
                    :published, :featured,
                    :intro, :media,
                    :photo, :raster_layer_project
                ]
            )
    end
end
