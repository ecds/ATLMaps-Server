class V1::CategoriesController < ApplicationController
    def index
        @categories = Category.all.order('name')
        render json: @categories,
               include: [
                   'tags'
               ]
    end

    def show
        @category = Category.find(params[:id])
        render json: @category,
               include: [
                   'tags'
               ]
    end
end
