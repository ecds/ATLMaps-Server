# frozen_string_literal: true

# Get rid of this when we switch to JSONAPI?
# Or use CanCanCan?
module Permissions
  #
  # Check if the current user has permission to edit project.
  #
  # @param [Project] project from request
  #
  # @return [Hash] Hash of permissions
  #
  def ownership(project)
    Rails.logger.debug("CURRENT USER - permims: #{current_user}")
    if current_user
      return {
        mine: current_user.id == project.user.id,
        may_edit: project.collaboration.map(&:user_id).include?(current_user.id) || current_user.id == project.user_id
      }
    else
      return {
        is_mine: false,
        may_edit: false
      }
    end
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def admin?
    current_user.user.admin if current_user.present?
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def user
    return current_user || false
  end
end
