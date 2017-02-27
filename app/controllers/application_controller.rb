class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # protect_from_forgery with: :exception
    # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
    # skip_before_filter :verify_authenticity_token, if: proc { |c| c.request.format == 'application/json' }

    include RailsApiAuth::Authentication

    # Method to get the user ID associated with the token being used.
    def current_user
        auth_header = request.headers['Authorization']
        return auth_header ? Login.where(oauth2_token: auth_header.split(' ').last).first! : false
    end

    private

    def default_serializer_options; end

    def pagination_dict(object)
        return {
            current_page: object.current_page,
            next_page: object.next_page,
            prev_page: object.prev_page,
            total_pages: object.total_pages,
            total_count: object.total_count
        }
    end
end
