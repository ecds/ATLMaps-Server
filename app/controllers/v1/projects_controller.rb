# frozen_string_literal: true

# app/controllers/api/v1/projects_controller.rb
class V1::ProjectsController < ApplicationController
  # class for Controller
  include Permissions
  include EcdsRailsAuthEngine::CurrentUser
  def index
    render(json: Project.featured)
  end

  def show
    project = Project.find(params[:id])
    # Only return the project if it is published, the user is the owner
    # or the user is a collaborator.
    # Rails.logger.debug("CURRENT USER: #{current_user}")
    permissions = ownership(project)
    # Rails.logger.debug("PERMISSIONS: #{permissions}")
    if project.published == true || permissions[:may_edit] == true
      render(
        json: project,
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
      )
    else
      # head(401)
      render(json: project, serializer: EmptyProjectSerializer)
    end
  end

  def create
    if current_user
      project = Project.new(project_params)
      project.saved = true
      project.user = current_user
      if project.save
        permissions = ownership(project)
        # Ember wants some JSON
        render(
          json: project,
          may_edit: permissions[:may_edit],
          mine: permissions[:mine],
          status: :created
        )
      else
        render(json: project.errors.details, status: :bad_request)
      end
    else
      head(401)
    end
  end

  def update
    @project = Project.find(params[:id])
    permissions = ownership(@project)
    if permissions[:may_edit] == true
      if @project.update(project_params)
        render(json: @project, status: :no_content)
      else
        head(500)
      end
    else
      head(401)
    end
  end

  def destroy
    project = Project.find(params[:id])
    permissions = ownership(project)
    if permissions[:mine]
      project.destroy
      head(204)
    else
      head(401)
    end
  end

  private

  def project_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse(
        params,
        only: %i[
          name
          saved
          description
          center_lat
          center_lng
          zoom_level
          default_base_map
          published
          featured
          intro
          media
          photo
          raster_layer_project
          user
        ]
      )
  end
end
