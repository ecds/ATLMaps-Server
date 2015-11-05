require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should create new project" do
    project = Project.find(2)

    user = User.find(project.user_id)
    assert_equal user.displayname, project.owner

    assert_equal 'neat-project', project.slug
    project.media = 'http://notyoutube.com'
    project.save
    refute project.valid?
    project.media = 'https://youtu.be/1m2cQjNhyaY'
    project.save
    assert project.valid?
  end

end
