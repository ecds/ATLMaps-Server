class Api::V1::TagsController < ApplicationController
  def index
    tags = Tag.all.all.order('name') 
    render json: tags
  end
  
  def show
    tag = Tag.find(params[:id])
    render json: tag
  end
end