class Api::V1::ProjectlayersController < ApplicationController
  def create
    projectlayer = Projectlayer.new(project_params)
    if projectlayer.save
      head 204, location: projectlayer
    end
  end
end
