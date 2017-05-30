ActiveModel::Serializer.config.adapter = ActiveModelSerializers::Adapter::JsonApi

ActiveModelSerializers.config.key_transform = :unaltered

ActiveSupport.on_load(:action_controller) do
    require 'active_model_serializers/register_jsonapi_renderer'
end

Mime::Type.register 'application/json', :json, %w(text/x-json application/jsonrequest application/vnd.api+json)
