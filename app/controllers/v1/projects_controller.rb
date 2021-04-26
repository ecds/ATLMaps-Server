# frozen_string_literal: true

# app/controllers/api/v1/projects_controller.rb
class V1::ProjectsController < ApplicationController
  # class for Controller
  include Permissions
  include EcdsRailsAuthEngine::CurrentUser

  before_action :set_project, only: %i(show destroy meta_only update)
  before_action :set_permissions, only: %i(show update destroy)

  #
  # Endpoint to serialize all featured projects.
  #
  # @return [JSON] Serialized json of featured projects.
  #
  def index
    render(json: Project.featured)
  end

  #
  # Endpoint to serialize project
  #
  # @return [JSON] Serialized json for a project
  #
  def show
    # Only return the project if it is published, the user is the owner
    # or the user is a collaborator.
    if @project.published == true || @permissions[:may_edit] == true
      render(
        json: @project,
        root: 'project',
        may_edit: @permissions[:may_edit],
        mine: @permissions[:mine],
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
      return
    end
    render(json: @project, serializer: EmptyProjectSerializer)
  end

  #
  # Endpoint to just return the metadata for the project and
  # and no associated layers. This is primarly used for serverside
  # rendering.
  #
  # @return [JSON] Serialized json for a project using `MetaOnlyProjectSerializer`
  #
  def meta_only
    render(json: @project, serializer: MetaOnlyProjectSerializer)
  end

  #
  # Endpoint to create project
  #
  # @return [JSON] Serialized json of newly created project.
  #
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

  #
  # Enpoint to update project
  #
  # @return [JSON] Serialized json for updated project
  #
  def update
    if @permissions[:may_edit] == true
      if @project.update(project_params)
        render(json: @project, status: :no_content)
      else
        head(500)
      end
    else
      head(401)
    end
  end

  #
  # Enpoint to delete project
  #
  # @return [HTTP] HTTP respone
  #
  def destroy
    if @permissions[:mine]
      @project.destroy!
      head(204)
    else
      head(401)
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  #
  # Set the permissions based on request.
  #
  def set_permissions
    @permissions = ownership(@project)
  end

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
