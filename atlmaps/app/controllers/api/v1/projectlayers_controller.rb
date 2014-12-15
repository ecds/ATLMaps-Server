class Api::V1::ProjectlayersController < ApplicationController

  def index
    @projectlayers = Projectlayer.all
  end

  def create
    projectlayer = Projectlayer.new(projectlayer_params)
    if projectlayer.save
      head 204
    end
  end
  
  private
    def projectlayer_params
      params.require(:projectlayer).permit(:project_id, :layer_id, :projectlayer)
    end
    
end
