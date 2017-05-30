class Api::V1::RasterLayerProjectsController < Api::V1::PermissionController
    def index
        # TODO: This should be a scope.
        projectlayers = if params[:raster_layer_id] && params[:project_id]
                            RasterLayerProject.where(
                                raster_layer_id: params[:raster_layer_id]
                            ).where(
                                project_id: params[:project_id]
                            ).first || {}
                        elsif params[:project_id]
                            RasterLayerProject.where(
                                project_id: params[:project_id]
                            )
                        else
                            RasterLayerProject.all
                        end

        render json: projectlayers, include: ['raster_layer']
    end

    def show
        # TODO: This should be a scope.
        projectlayer = if params[:raster_layer_id]
                           RasterLayerProject.where(
                               raster_layer_id: params[:raster_layer_id]
                           ).where(
                               project_id: params[:project_id]
                           ).first
                       else
                           RasterLayerProject.find(params[:id])
                       end

        render json: projectlayer, include: ['raster_layer']
    end

    # def create
    #     # TODO: Something isn't right here.
    #     project = Project.find(params[:rasterLayerProject][:project_id])
    #     permissions = ownership(project)
    #     if permissions[:may_edit] == true
    #         projectlayer = RasterLayerProject.new(raster_layer_project_params)
    #         if projectlayer.save
    #             # Ember wants some JSON
    #             render json: projectlayer, status: 201
    #         else
    #             head 500
    #         end
    #     else
    #         head 301
    #     end
    # end
    def create
        project = Project.find(raster_layer_project_params[:project_id])
        raster_layer = RasterLayer.find(params['data']['relationships']['raster_layer']['data']['id'])
        permissions = ownership(project)
        if permissions[:may_edit] == true
            projectlayer = RasterLayerProject.new(raster_layer_project_params)
            projectlayer.raster_layer = raster_layer
            projectlayer.project = project
            if projectlayer.save
                # Ember wants some JSON
                render jsonapi: projectlayer, status: 201
            else
                head 500
            end
        else
            head 301
        end
    end

    def update
        project_layer = RasterLayerProject.find(params[:id])
        permissions = ownership(project_layer.project)
        if permissions[:may_edit] == true
            if project_layer.update(raster_layer_project_params)
                render json: {}, status: 204
            else
                head 500
            end
        else
            head 401
        end
    end

    def destroy
        project_layer = RasterLayerProject.find(params[:id])
        permissions = ownership(project_layer.project)
        if permissions[:may_edit] == true
            project_layer.destroy
            render json: {}, status: 204
        else
            head 401
        end
    end

    private

    def raster_layer_project_params
        ActiveModelSerializers::Deserialization.jsonapi_parse(params,
                           only: [
                               :project_id,
                               :raster_layer_id,
                               :data_format,
                               :position
                           ])
    end
end
