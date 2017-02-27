class Api::V1::PermissionController < ApplicationController
    def user_id
        current_user ? current_user.user.id : false
    end

    def user
        return current_user ? current_user.user : false
    end

    def ownership(project)
        if current_user
            return {
                mine: user_id == project.user_id,
                may_edit: project.collaboration.map(&:user_id).include?(user_id) || user_id == project.user_id
            }
        else
            return {
                is_mine: false,
                may_edit: false
            }
        end
    end
end
