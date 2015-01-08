class Api::V1::TokensController < ApplicationController
  before_action :doorkeeper_authorize!
  respond_to     :json

  def me
    respond_with current_resource_owner
  end

end
