class Api::V1::MayEditController < ApplicationController
    def may_edit(project)
        authenticate! do
            return defined?(current_user.user.id) \
            && (mine(project) \
            || collaborator(project))
        end

        return false
    end

    def mine(project)
        authenticate! do
            return defined?(current_user.user.id) \
            && (current_user.user.id == project.user_id)
        end

        return false
    end

    def collaborator(project)
        authenticate! do
            return defined?(current_user.user.id) \
            && (project.collaboration.map(&:user_id).include? \
                current_user.user.id)
        end

        return false
    end
end
