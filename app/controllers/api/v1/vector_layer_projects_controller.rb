# Controller class for vector layers included in a project.
class Api::V1::VectorLayerProjectsController < Api::V1::PermissionController
    def index
        # TODO: This should be a scope.
        projectlayers = if params[:vector_layer_id]
                            VectorLayerProject.where(
                                vector_layer_id: params[:vector_layer_id]
                            ).where(
                                project_id: params[:project_id]
                            )
                        elsif params[:project_id]
                            VectorLayerProject.where(
                                project_id: params[:project_id]
                            )
                        else
                            VectorLayerProject.all
                        end

        render json: projectlayers
    end

    def show
        # TODO: This should be a scope.
        projectlayer = if params[:vector_layer_id]
                           VectorLayerProject.where(
                               vectorr_layer_id: params[:vector_layer_id]
                           ).where(
                               project_id: params[:project_id]
                           ).first
                       else
                           VectorLayerProject.find(params[:id])
                       end

        render json: projectlayer
    end

    def create
        project = Project.find(params[:vectorLayerProject][:project_id])
        permissions = ownership(project)
        if permissions[:may_edit] == true
            projectlayer = VectorLayerProject.new(vector_layer_project_params)
            if projectlayer.save
                # Ember wants some JSON
                render json: projectlayer, status: 201
            else
                head 500
            end
        else
            head 301
        end
    end

    def update
        project_layer = VectorLayerProject.find(params[:id])
        permissions = ownership(project_layer.project)
        if permissions[:may_edit] == true
            if project_layer.update(vector_layer_project_params)
                render json: project_layer, status: 201
            else
                head 500
            end
        else
            head 401
        end
    end

    def destroy
        project_layer = VectorLayerProject.find(params[:id])
        permissions = ownership(project_layer.project)
        if permissions[:may_edit] == true
            project_layer.destroy
            project_layer.destroy
            render json: {}, status: 204
        else
            head 401
        end
    end

    private

    def vector_layer_project_params
        params.require(:vectorLayerProject).permit(
            :project_id, :vector_layer_id, :marker, :data_format, :position
        )
    end
end
