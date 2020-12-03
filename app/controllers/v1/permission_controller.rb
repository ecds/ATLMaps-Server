# frozen_string_literal: true

# Controller class to create some common methods to verify the permissions on a request.
class V1::PermissionController < ApplicationController
  def ownership(project)
    if current_user&.user&.confirmed
      return {
        mine: user_id == project.user.id,
        may_edit: project.collaboration.map(&:user_id).include?(user_id) || user_id == project.user_id
      }
    else
      return {
        is_mine: false,
        may_edit: false
      }
    end
  end

  private

  def user_id
    current_user ? current_user.user.id : false
  end

  def user
    return current_user ? current_user.user : false
  end
end
