class Api::V1::MayEditController < ApplicationController
    before_action :authenticate!

    def may_edit(project)
        puts "\n\n\n\n\n\n\n\n\n\n\n\n********************"
        puts current_user.user.id
        puts "\n\n\n\n\n\n\n\n\n\n\n\n********************"
        return defined?(current_user.user.id) && (mine(project) || collaborator(project))
    end

    def mine(project)
        return defined?(current_user.user.id) && (current_user.user.id == project.user_id)
    end

    def collaborator(project)
        return defined?(current_user.user.id) && (project.collaboration.map(&:user_id).include? current_user.user.id)
    end
end
