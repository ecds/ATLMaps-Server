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
    project.media = 'https://youtube.com/watch?v=r6E3J4GPpjc'
    project.save
    assert project.valid?
    project.media = 'https://vimeo.com/channels/staffpicks/45322909'
    project.save
    assert project.valid?
  end

  test "get parameterized template" do
    project = Project.find(1)

    assert_equal 'article-and-video', project.templateSlug
  end

end
