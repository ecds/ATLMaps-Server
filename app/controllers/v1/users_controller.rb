# frozen_string_literal: true

# Controller that retunrns users.
# If the index method sees a parameter of `me` and there is a `current_user`
# assoiated with the call, the user is returned so the frontend can display
# the user's info.
class V1::UsersController < ApplicationController
  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def index
    if current_user && params['me']
      grr = User.where(id: current_user.user.id).first
      render(json: grr)
    elsif !current_user.confirmed
      render(json: { errors: "Check email for #{current_user.identifier} for confirmation email." }.to_json, status: :unauthorized)
    else
      render(json: {}.to_json, status: :unauthorized)
    end
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def show
    render(json: current_user)
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def create
    user = Login.new(login_params)
    if user.save
      render(json: user.user, status: :created)
    else
      render(json: user.errors.details, status: :bad_request)
    end
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def update
    if current_user.id.to_s == params[:id]
      current_user.update!(user_params)
      render(json: current_user, status: :no_content)
    else
      render(json: { cu: current_user.id, pid: params[:id] })
    end
  end

  private

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:displayname])
  end

  def login_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: %i[identification password])
  end
end
