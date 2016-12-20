class Api::V1::UsersController < ApplicationController

  def index
    if @current_login
      # if params[:project_id]
      #   projects = Project.where(name: params[:name])
      # end
      @users = User.where.not(id: @current_login.id)#.where.not('collaboration.project_id' => parmas[:project_id])
    else
      #@users = User.where.not('project_id' => params[:project_id])
      @users = User.all
    end
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
    #respond_to do |format|
    #  format.json { render json: layer, status: :ok }
    #end
  end

  before_action :authenticate!, only: :me
    def me
        user = @current_login.user

        if user.nil?
            render json: {}, status: 400
        else
            render json: user
            #or render as json:api for ember using the jsonapi-resources gem
            #render json: JSONAPI::ResourceSerializer.new(UserResource).serialize_to_hash(UserResource.new(user, nil))
        end
    end

end
