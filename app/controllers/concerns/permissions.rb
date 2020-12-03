# frozen_string_literal: true

# Get rid of this when we switch to JSONAPI?
module Permissions
  def ownership(project)
    Rails.logger.debug("CURRENT USER - permims: #{current_user}")
    if current_user # && current_user.confirmed
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
  def user_id
    34
    # current_user ? current_user.id : false
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
