require 'rails_helper'

RSpec.describe V1::ProjectsController, type: :controller do
  describe 'POST create' do
    it 'has 401 when no user authenticated' do
      post :create
      expect(response.status).to(eq(401))
    end

    it 'creates project when user is authenticated' do
      user = create(:user)
      signed_cookie(user)
      post :create
      expect(response.status).to(eq(201))
    end
  end

  describe 'GET index' do
    it 'returns list of featured projects' do
      create_list(:project, 5, featured: true, user: create(:user))
      create_list(:project, 4, featured: false, user: create(:user))
      expect(Project.all.count).to(eq(9))
      get :index
      expect(json.count).to(eq(5))
    end

    # it 'returns list of projects that are featured and/or belong to authenticated user' do
    #   user = create(:user)
    #   create_list(:project, 5, featured: true, user: create(:user))
    #   create_list(:project, 3, featured: false, user: create(:user))
    #   create_list(:project, 4, featured: false, user: user)
    #   expect(Project.all.count).to(eq(12))
    #   signed_cookie(user)
    #   get :index
    #   expect(json.count).to(eq(9))
    # end
  end
end
