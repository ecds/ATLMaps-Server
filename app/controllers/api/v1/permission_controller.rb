class Api::V1::PermissionController < ApplicationController
    def ownership(project)
        if current_user
            return {
                is_mine: current_user.user.id == project.user_id || false,
                may_edit: current_user.user.id == project.user_id || \
                          (project.collaboration.map(&:user_id).include? \
                              current_user.user.id) || false
            }
        else
            return {
                is_mine: false,
                may_edit: false
            }
        end
    end
end
