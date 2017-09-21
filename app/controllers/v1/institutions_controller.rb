# Controller class for Institutions
class V1::InstitutionsController < ApplicationController
    def index
        @institutions = if params[:q]
                            Institution.where('name ILIKE ?', "%#{params[:q]}%")
                        else
                            Institution.all.order('name')
                        end
        render json: @institutions
    end

    def show
        institution = Institution.find(params[:id])
        render json: institution
    end
end
