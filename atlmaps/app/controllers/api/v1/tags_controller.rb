class Api::V1::TagsController < ApplicationController
  def index
    tags = Tag.all
    render json: tags
  end
  
  def show
    tag = Tag.find(params[:id])
    render json: tag
  end
end
