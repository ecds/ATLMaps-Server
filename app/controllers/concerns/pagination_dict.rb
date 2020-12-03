# frozen_string_literal: true

# Get rid of this when we switch to JSONAPI
module PaginationDict
  def pagination_dict(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end

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

  def user_id
    current_user ? current_user.user.id : false
  end

  def user
    return current_user ? current_user.user : false
  end
end
