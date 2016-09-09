class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # rescue_from(Exception) {
  #   render json: {errors: {msg: 'Shit'} },
  #   status: 500
  # }

  private

  	def default_serializer_options

	end

    # FIXME Everything about this is awful!

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def mine(project)
      if current_resource_owner && current_resource_owner.id == project.user_id
        return true
      else
        return false
      end
    end

    def collaborator(project)
      if current_resource_owner and project.collaboration.present?
        # make an array of the user ids of collaborators
        collaborations = project.collaboration.map {|c| c.user_id}
        if collaborations.any? and collaborations.include? current_resource_owner.id
          return true
        else
          return false
        end
      else
        return false
      end
    end

    def mayedit(project)
      if collaborator(project) or mine(project)
        return true
      else
        return false
      end
    end

end
