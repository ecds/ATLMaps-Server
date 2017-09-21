# Class to manage wheather or not a user has confirmed their address.
# FIXME: This feels pretty hacky, but I need to get this out. On the client
# side, we need a better way to hit an endpoint without having an acutal object.
class V1::ConfirmationTokensController < ApplicationController
    # This is the hacky part. Given Eber Data, we have to have an object to update,
    # we can just call save on a model with no objects. So we make up a bullshit
    # object so we can call `save()` on it to make a `PATCH` request. We can't
    # just make a `PATCH` request with some parameters.
    def index
        # So if a `GET` request
        # comes in with a `confirm_token`, we find the `Login` with that `confirm_token`
        # and set it to `nil`, and `email_confirmed` to `true` which means it is confirmed.
        if params['confirm_token']
            login = Login.where(confirm_token: params['confirm_token']).first
            login.confirm_token = nil
            login.email_confirmed = true
            if login.save
                render json: {
                    data: [
                        {
                            id: login.id,
                            type: 'confirmation_tokens',
                            attributes: {}
                        }
                    ]
                }.to_json, status: 200
            else
                render json: login.errors.details, status: 400
            end
        else
            render json: { data: [{ id: 999, type: 'confirmation_tokens', attributes: {} }] }.to_json, status: 200
        end
    end

    # This would be better to break into different methods.
    def show
        # If there is no `confirm_token` in the params, we are resending a new
        # `confirm_token`.
        current_user.confirm_token = SecureRandom.urlsafe_base64.to_s
        if current_user.save
            ConfirmLoginMailer.registration_confirmation(current_user).deliver
            render json: { data: { id: 1, type: 'confirmation_tokens', attributes: {} } }.to_json, status: 200
        else
            head 500
        end
    end
end
