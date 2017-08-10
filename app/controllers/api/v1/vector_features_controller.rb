class Api::V1::VectorFeaturesController < ApplicationController
    def show
        feature = VectorFeature.find(params[:id])
        # end
        render json: feature
        # respond_to do |format|
        #  format.json { render json: layer, status: :ok }
        # end
    end

    def create
        factory = RGeo::Geographic.simple_mercator_factory
        # properties: feature.properties,
        # geometry_type: feature.geometry.geometry_type,
        # geometry_collection: factory.collection([feature.geometry]),
        # vector_layer: v
        geojson = params[:data][:attributes][:geojson]
        coordinates = geojson[:geometry][:coordinates]
        feature = VectorFeature.new(
            properties: geojson[:properties],
            geometry_type: geojson[:geometry][:type],
            # factory.collection([factory.point(c[0], c[1])])
            geometry_collection: factory.collection([factory.point(coordinates[0], coordinates[1])]),
            # "data"=>{"type"=>"vector-layers", "id"=>"189"}}
            vector_layer: VectorLayer.find(params[:data][:relationships][:vector_layer][:data][:id])
        )
        render jsonapi: feature, status: 201 if feature.save
    end

    private

    def feature_params
        ActiveModelSerializers::Deserialization
            .jsonapi_parse(
                params, only: [
                    :geojson, :vector_layer
                ]
            )
    end
end
