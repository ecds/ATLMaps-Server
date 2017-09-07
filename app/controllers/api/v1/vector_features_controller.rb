# app/controllers/api/v1/vector_features_controller.rb
class Api::V1::VectorFeaturesController < ApplicationController
    include Permissions
    def show
        @feature = VectorFeature.find(params[:id])
        render json: @feature
    end

    def create
        factory = RGeo::Geographic.simple_mercator_factory
        geojson = params[:data][:attributes][:geojson]
        coordinates = geojson[:geometry][:coordinates]
        feature = VectorFeature.new(
            # TODO: Should this be in the model?
            properties: geojson[:properties],
            geometry_type: geojson[:geometry][:type],
            geometry_collection: factory.collection([factory.point(coordinates[0], coordinates[1])]),
            vector_layer: VectorLayer.find(params[:data][:relationships][:vector_layer][:data][:id])
        )
        render jsonapi: feature, status: 201 if feature.save
    end

    def update
        if admin?
            @layer_feature = VectorLayerFeature.find(params[:id])
            if @layer_feature.update(layer_params)
                # render json: @stop
                head :no_content
            else
                render json: @layer_feature.errors, status: :unprocessable_entity
            end
        else
            render json: 'Bad credentials', status: 401
        end
    end

    private

    def feature_params
        ActiveModelSerializers::Deserialization
            .jsonapi_parse(
                params, only: %i[
                    geojson vector_layer
                ]
            )
    end
end
