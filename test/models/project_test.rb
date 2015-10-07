require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should create new project" do
    project = Project.find(2)

    user = User.find(project.user_id)
    assert_equal user.displayname, project.owner

    assert_equal 'neat-project', project.slug
  end

end
