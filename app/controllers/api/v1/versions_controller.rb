class Api::V1::VersionsController < ApplicationController
    def index
        render json: APP_VERSION
    end
end
